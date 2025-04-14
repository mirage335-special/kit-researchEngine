
# https://github.com/open-webui/open-webui/discussions/11930?utm_source=chatgpt.com
# https://www.openwebui.com/f/coker/openai

# https://en.wikipedia.org/wiki/MIT_License
# Copyright (c) <year> <copyright holders>

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



"""
title: OpenAI Responses Pipe
author_url:https://linux.do/u/coker/summary
author: coker
version: 0.0.2
license: MIT
"""

from pydantic import BaseModel, Field
import httpx
import json
import random


class Pipe:
    class Valves(BaseModel):
        NAME_PREFIX: str = Field(
            default="OpenAI: ",
            description="Prefix to be added before model names.",
        )
        BASE_URL: str = Field(
            default="https://api.openai.com/v1",
            description="Base URL for OpenAI API.",
        )
        API_KEYS: str = Field(
            default="",
            description="API keys for OpenAI, use , to split",
        )
        THINKING_EFFORT: str = Field(
            default="medium",
            description="low ,medium, high",
        )

    def __init__(self):
        self.valves = self.Valves()
        self.openai_response_models = [
            "o1-pro",
            "gpt-4.5-preview",
            "o1",
            "chatgpt-4o-latest",
            "o3-mini",
        ]
        self.not_supported_efforts_models = ["chatgpt-4o-latest", "gpt-4.5-preview"]

    def pipes(self):
        res = []
        if self.openai_response_models:
            for model in self.openai_response_models:
                res.append({"name": f"{self.valves.NAME_PREFIX}{model}", "id": model})
        return res

    async def pipe(self, body: dict, __user__: dict):
        self.key = random.choice(self.valves.API_KEYS.split(",")).strip()
        print(f"pipe:{__name__}")
        headers = {
            "Authorization": f"Bearer {self.key}",
            "Content-Type": "application/json",
        }
        model_id = body["model"][body["model"].find(".") + 1 :]
        payload = {**body, "model": model_id}
        # Remove the old parameter if it exists
        payload.pop("reasoning_effort", None)
        payload["stream"] = True
        if model_id not in self.not_supported_efforts_models:
            payload["reasoning"] = {"effort": self.valves.THINKING_EFFORT.strip()}

        if model_id in self.openai_response_models:
            new_messages = []
            messages = body["messages"]
            for message in messages:
                try:
                    if message["role"] == "user":
                        if isinstance(message["content"], list):
                            content = []
                            for i in message["content"]:
                                if i["type"] == "text":
                                    content.append(
                                        {"type": "input_text", "text": i["text"]}
                                    )
                                elif i["type"] == "image_url":
                                    content.append(
                                        {
                                            "type": "input_image",
                                            "image_url": i["image_url"]["url"],
                                        }
                                    )
                            new_messages.append({"role": "user", "content": content})
                        else:
                            new_messages.append(
                                {
                                    "role": "user",
                                    "content": [
                                        {
                                            "type": "input_text",
                                            "text": message["content"],
                                        }
                                    ],
                                }
                            )
                    elif message["role"] == "assistant":
                        new_messages.append(
                            {
                                "role": "assistant",
                                "content": [
                                    {"type": "output_text", "text": message["content"]}
                                ],
                            }
                        )
                    elif message["role"] == "system":
                        new_messages.append(
                            {
                                "role": "system",
                                "content": [
                                    {"type": "input_text", "text": message["content"]}
                                ],
                            }
                        )
                except Exception:
                    yield f"Error: {message}"
                    return
            payload.pop("messages")
            payload["input"] = new_messages
        else:
            yield f"Error: Model {model_id} unKnown"
            return
        try:
            async with httpx.AsyncClient(timeout=600) as client:
                async with client.stream(
                    "POST",
                    f"{self.valves.BASE_URL}/responses",
                    json=payload,
                    headers=headers,
                ) as response:
                    if response.status_code != 200:
                        error_text = await response.aread()
                        yield f"Error: {response.status_code} {error_text.decode('utf-8')}"
                        return

                    async for line in response.aiter_lines():
                        if line:
                            try:
                                if line.startswith("data:"):
                                    line_data = json.loads(line[5:])
                                    yield line_data["delta"]
                            except Exception:
                                pass
        except Exception as e:
            yield f"Error: {e}"
            return
