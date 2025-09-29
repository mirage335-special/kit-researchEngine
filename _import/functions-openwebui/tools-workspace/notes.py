"""ALWAYS use the notes_search_smart() function . Infer anything that might be a search query, such as having been asked a question, asked to find information, requested to search for documentation , a mention of searching through notes , or anything else that might be a search query. Generate plausible queries.

You do have the tool to search for information, search through personal notes, etc, generate queries and use the notes_search_smart() function.
"""

"""
name: Trilium ETAPI (OpenWebUI Tool)
description: Read‑only smart search over TriliumNext ETAPI. All write/delete endpoints have been removed/disabled.
author: mirage335
version: 0.3.1 (smart‑search only)
license: No additional license claims by author, presumably inherits from any derivative code (if any) AGPLv3 license from https://github.com/Nriver/trilium-py , or CC0 Public Domain .
notes:
- This build exposes ONLY `trilium_search_smart(...)` (read‑only). All other functions are commented out to prevent accidental writes/deletes.
- Inclusive by default: includes archived notes, expands queries, and can fetch content snippets for text/code notes.

https://triliumnext.github.io/Docs/Wiki/etapi.html
https://github.com/Nriver/trilium-py
https://web.archive.org/web/20250419190208/https://github.com/TriliumNext/Notes/blob/develop/src/etapi/etapi.openapi.yaml

"""

import os
import re
import html
from typing import Optional, List, Literal, Dict, Any, Tuple
import requests
from pydantic import BaseModel, Field
from requests.auth import HTTPBasicAuth


class Tools:
    # === Admin‑configurable fields (Valves) ===
    class Valves(BaseModel):
        TRILIUM_URL: str = Field(
            default=os.getenv("TRILIUM_URL", "http://localhost:8080"),
            description="Base URL of your TriliumNext server (no trailing slash).",
        )
        ETAPI_TOKEN: Optional[str] = Field(
            default=os.getenv("TRILIUM_ETAPI_TOKEN"),
            description="ETAPI token from Trilium Options → ETAPI.",
        )
        AUTH_MODE: Literal["token_header", "basic"] = Field(
            default="token_header",
            description="Auth style: 'token_header' uses Authorization: <token>. 'basic' uses user 'etapi' and password=<token>.",
        )
        VERIFY_TLS: bool = Field(
            default=(os.getenv("TRILIUM_VERIFY_TLS", "true").lower() != "false"),
            description="Verify HTTPS certificates (disable only for self‑signed).",
        )
        TIMEOUT_S: int = Field(
            default=int(os.getenv("TRILIUM_TIMEOUT_S", "30")),
            description="HTTP timeout in seconds.",
        )

    def __init__(self):
        self.valves = self.Valves()

    # ---------- helpers ----------
    def _base(self) -> str:
        return self.valves.TRILIUM_URL.rstrip("/") + "/etapi"

    def _session(self) -> requests.Session:
        s = requests.Session()
        s.verify = self.valves.VERIFY_TLS
        s.headers.update({"Accept": "application/json"})
        token = self.valves.ETAPI_TOKEN
        if token:
            if self.valves.AUTH_MODE == "basic":
                s.auth = HTTPBasicAuth("etapi", token)
            else:
                s.headers["Authorization"] = token  # raw token per ETAPI
        return s

    def _raise_for_status(self, resp) -> None:
        try:
            resp.raise_for_status()
        except requests.HTTPError as e:
            try:
                return_msg = resp.json()
            except Exception:
                return_msg = resp.text
            raise RuntimeError(f"ETAPI error {resp.status_code}: {return_msg}") from e

    def _coerce(self, model_cls, payload):
        if isinstance(payload, model_cls):
            return payload
        if isinstance(payload, dict):
            return model_cls(**payload)
        raise TypeError(f"Expected {model_cls.__name__} or dict, got {type(payload)}")

    def _strip_html(self, html_text: str) -> str:
        text = re.sub(r"<\s*br\s*/?\s*>", "\n", html_text, flags=re.I)
        text = re.sub(r"<[^>]+>", "", text)
        return html.unescape(text)

    # ---------- input model (smart search only) ----------
    class SmartSearchInput(BaseModel):
        search: str = Field(
            ..., description="Freeform query. We'll try variants and merge results."
        )
        ancestorNoteId: Optional[str] = None
        includeArchived: bool = True
        fetchContent: bool = True
        stripHtml: bool = True
        # ultra‑inclusive tuning
        mode: Literal["balanced", "inclusive"] = "inclusive"
        keepBooleanWords: bool = True  # keep OR/AND/NOT as tokens in inclusive mode
        limitPerVariant: int = 500  # server‑side cap per variant (requires orderBy)
        maxNotes: int = 100  # final union cap
        maxCharsPerNote: int = 1500

    """ Use the notes_search_smart() function if asked to find information, search for documentation , search through notes , or anything else that might be a search query. """

    # ---------- READ‑ONLY: ultra‑inclusive one‑shot search ----------
    def notes_search_smart(self, input: SmartSearchInput) -> str:
        """Ultra‑inclusive read‑only search that expands the query and (optionally) fetches snippets.
        This is the ONLY exposed function to avoid accidental writes/deletes."""
        input = self._coerce(self.SmartSearchInput, input)
        sess = self._session()
        base_url = f"{self._base()}/notes"

        def base_params():
            p = {"includeArchived": "true" if input.includeArchived else "false"}
            p["orderBy"] = ["title"]  # needed when limit is present
            p["limit"] = input.limitPerVariant
            return p

        # Tokenize; optionally keep boolean words for inclusiveness
        raw_tokens = re.findall(r"[\w-]+", input.search)
        if input.mode == "inclusive" and input.keepBooleanWords:
            tokens = raw_tokens[:]  # keep OR/AND/NOT
        else:
            tokens = [t for t in raw_tokens if t.lower() not in ("or", "and", "not")]
        tokens = [t for t in tokens if t]

        variants: List[Tuple[str, Dict[str, Any]]] = []
        # Original (fast)
        p = base_params()
        p.update({"search": input.search, "fastSearch": "true"})
        variants.append(("fast:original", p))
        # OR‑joined tokens (fast)
        if len(tokens) >= 2:
            p = base_params()
            p.update({"search": " OR ".join(tokens), "fastSearch": "true"})
            variants.append(("fast:OR-joined", p))
        # Each token (fast)
        for t in tokens:
            p = base_params()
            p.update({"search": t, "fastSearch": "true"})
            variants.append((f"fast:token:{t}", p))
        # Regex on title (slow)
        if len(tokens) >= 2:
            regex = f"note.title %= '.*({'|'.join(tokens)}).*'"
            p = base_params()
            p.update({"search": regex, "fastSearch": "false"})
            variants.append(("regex:title", p))
        # Regex generic (slow) — very broad, last resort
        if len(tokens) >= 1:
            regex_any = f".*({'|'.join(tokens)}).*"
            p = base_params()
            p.update({"search": regex_any, "fastSearch": "false"})
            variants.append(("regex:any", p))

        # Execute & merge
        agg: Dict[str, Dict[str, Any]] = {}
        errors: List[str] = []
        for label, params in variants:
            try:
                r = sess.get(base_url, params=params, timeout=self.valves.TIMEOUT_S)
                self._raise_for_status(r)
                for row in r.json().get("results") or []:
                    nid = row.get("noteId")
                    if not nid:
                        continue
                    entry = agg.setdefault(
                        nid, {"title": row.get("title"), "via": set()}
                    )
                    entry["via"].add(label)
            except Exception as e:
                errors.append(f"{label}: {e}")

        hits = [(nid, v) for nid, v in agg.items()]
        if not hits:
            return "No hits." + (" Errors: " + "; ".join(errors) if errors else "")

        # Cap and optionally fetch content
        hits = hits[: input.maxNotes]
        lines: List[str] = []
        for nid, meta in hits:
            title = meta.get("title") or "(untitled)"
            via = ",".join(sorted(meta.get("via", [])))
            if input.fetchContent:
                kind = None
                try:
                    note_meta = sess.get(
                        f"{self._base()}/notes/{nid}", timeout=self.valves.TIMEOUT_S
                    )
                    self._raise_for_status(note_meta)
                    kind = (note_meta.json() or {}).get("type")
                except Exception:
                    kind = None
                content_text = ""
                if kind in ("text", "code"):
                    try:
                        c = sess.get(
                            f"{self._base()}/notes/{nid}/content",
                            timeout=self.valves.TIMEOUT_S,
                        )
                        self._raise_for_status(c)
                        body = c.text
                        if input.stripHtml:
                            body = self._strip_html(body)
                        content_text = body.strip().replace("\r\n", "\n")[
                            : input.maxCharsPerNote
                        ]
                    except Exception as e:
                        content_text = f"[error reading content: {e}]"
                else:
                    content_text = f"[non-text note type: {kind or 'unknown'}]"
                lines.append(f"{nid} | {title} | via={via}\n{content_text}\n---")
            else:
                lines.append(f"{nid} | {title} | via={via}")
        if errors:
            lines.append("[variant errors] " + "; ".join(errors))
        return "\n".join(lines)

    # --------------------
    # DISABLED (commented‑out) functions to avoid accidental writes/deletes.
    # If you ever need them back, remove the triple‑quotes below.
    """
    def trilium_app_info(self) -> str: ...
    def trilium_login(self, input): ...
    def trilium_search_notes(self, input): ...
    def trilium_get_note(self, input): ...
    def trilium_get_note_content(self, input): ...
    def trilium_set_note_content(self, input): ...
    def trilium_create_note(self, input): ...
    def trilium_patch_note(self, input): ...
    def trilium_delete_note(self, input): ...
    def trilium_debug_probe(self) -> str: ...
    def trilium_search_expand(self, input): ...
    """
