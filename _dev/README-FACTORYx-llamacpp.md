


# Example - Inference

ATTRIBUTION-AI: ChatGPT o4-mini-high  2025-05-15

DUBIOUS.

Do not set '--gpu-layers 0', may default to CPU inference.

Alternatively, CPU inference may be useful if testing a fine tuned model with GPU still in use somehow.

```bash
./llama-cli -m ~/models/file.gguf --gpu-layers 33 --no-mmap -t 16 -b 128 -c 2048 -n 512
```







