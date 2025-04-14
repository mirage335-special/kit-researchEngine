
# Alternative to ubChatGPT custom GPT available from 'https://chatgpt.com/g/g-67f53f2954dc8191a6df722dbcce512a-ubchatgpt' .
# Created using same system prompt and knowledge, nominally differing in using ChatGPT 4.5-preview as backend .
# In practice, may sometimes explain better, trace across functions, etc, less, and hallucinate less. Usually 'ubChatGPT' is preferable for better tracing, despite often just making stuff up.
#
# Script derived from:
#  https://github.com/open-webui/open-webui/discussions/3659
#  https://openwebui.com/f/mantonherre/assistant_openai
#  https://github.com/Mantonherre/OpenWebUI-Assistant-OpenAI.git
#
# GitHub python script was identical to openwebui community posted script.
#
# Obtained without explicit license. Fair use, public domain, or GitHub default license assumed.
#  
# Modified to automatically install dependencies and attempt to resolve responsiveness issues.
#
# Not regarded as essential.


import subprocess
import sys

required_packages = ["openai", "pydantic", "typing-extensions"]


def install_packages(packages):
    subprocess.check_call(
        [sys.executable, "-m", "pip", "install", "--upgrade"] + packages
    )


try:
    import openai
    from pydantic import BaseModel, Field
    from typing import List
except ImportError:
    install_packages(required_packages)
    import openai
    from pydantic import BaseModel, Field
    from typing import List

import os
import asyncio


class Pipe:
    class Valves(BaseModel):
        OPENAI_API_KEY: str = Field(default="")

    def __init__(self):
        self.type = "manifold"
        self.id = "openai"
        self.name = "openai/"
        self.valves = self.Valves(
            OPENAI_API_KEY=os.getenv("OPENAI_API_KEY", "api_key_number")
        )
        if not self.valves.OPENAI_API_KEY:
            raise ValueError(
                "API Key is required. Set OPENAI_API_KEY as an environment variable."
            )
        openai.api_key = self.valves.OPENAI_API_KEY
        self.assistant_id = "asst_fFAsRnagXqPV3Dk8kfYXUG3R"

    def pipes(self) -> List[dict]:
        return [{"id": self.assistant_id, "name": "ubChatGPT"}]

    def process_messages(self, messages: List[dict]) -> List[dict]:
        processed_messages = []
        for msg in messages:
            text_content = msg.get("content", "")
            if isinstance(text_content, list):
                text_content = " ".join(
                    [item["text"] for item in text_content if item["type"] == "text"]
                )
            processed_messages.append({"role": msg["role"], "content": text_content})
        return processed_messages

    async def run_assistant(self, processed_messages: List[dict]) -> str:
        thread = openai.beta.threads.create()
        thread_id = thread.id

        for message in processed_messages:
            openai.beta.threads.messages.create(
                thread_id=thread_id,
                role=message["role"],
                content=message["content"],
            )

        run = openai.beta.threads.runs.create(
            thread_id=thread_id,
            assistant_id=self.assistant_id,
        )

        while True:
            run_status = openai.beta.threads.runs.retrieve(
                thread_id=thread_id, run_id=run.id
            )
            if run_status.status in ("completed", "failed", "cancelled", "expired"):
                break
            await asyncio.sleep(0.5)

        if run_status.status != "completed":
            return f"[Error]: Assistant stopped with status {run_status.status}."

        # Fetch all messages and concatenate text outputs from the assistant
        messages = openai.beta.threads.messages.list(thread_id=thread_id)
        assistant_replies = []
        for message in reversed(messages.data):  # oldest → newest
            if message.role == "assistant":
                for content_item in message.content:
                    if content_item.type == "text":
                        assistant_replies.append(content_item.text.value.strip())

        # Join these replies clearly and separate them logically
        full_response = "\n\n".join(assistant_replies).strip()

        if full_response:
            return full_response
        else:
            return "[No visible response from assistant.]"

    async def pipe(self, body: dict) -> str:
        processed_messages = self.process_messages(body.get("messages", []))
        try:
            result = await self.run_assistant(processed_messages)
            return result
        except Exception as e:
            return f"[Exception]: {str(e)}"


if __name__ == "__main__":
    pipe = Pipe()
    print(pipe.pipes())
