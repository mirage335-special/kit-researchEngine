
# Further

Some sort of interactive config for generating axolotl yaml may be available, and better maintained thus more correct.

Fine tuning guide specifically for Llama 3.1 recommends Axolotl (which apparently supports Unsloth as a backend, though that may not be relevant), specifically for multi-GPU support.

Different versions of axolotl may be less problematic.

Commands used with unsloth may be, at least with AI RAG assistance, adaptable to axolotl if necessary for multi-GPU support.

NVIDIA drivers installed with older eGPU present may have disabled support for some crucial features.



# Reference



https://huggingface.co/blog/mlabonne/sft-llama3
https://huggingface.co/mlabonne/FineLlama-3.1-8B-GGUF/tree/main
https://huggingface.co/collections/unsloth/llama-31-collection-6753dca76f47d9ce1696495f





https://axolotl.ai/
https://github.com/axolotl-ai-cloud/axolotl
https://github.com/axolotl-ai-cloud/axolotl/tree/main?tab=readme-ov-file

https://axolotl-ai-cloud.github.io/axolotl/docs/getting-started.html
https://axolotl-ai-cloud.github.io/axolotl/docs/installation.html

https://docs.runpod.io/tutorials/pods/fine-tune-llm-axolotl

https://axolotl-ai-cloud.github.io/axolotl/docs/multi-gpu.html

https://axolotl-ai-cloud.github.io/axolotl/docs/nccl.html
https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/env.html

https://axolotl-ai-cloud.github.io/axolotl/docs/config.html

https://github.com/axolotl-ai-cloud/axolotl/tree/main/examples/llama-3
https://github.com/axolotl-ai-cloud/axolotl/blob/main/examples/llama-3/instruct-lora-8b.yml
https://github.com/axolotl-ai-cloud/axolotl/blob/main/examples/llama-3/lora-8b.yml
https://github.com/axolotl-ai-cloud/axolotl/blob/main/examples/llama-3/lora-1b.yml
https://github.com/axolotl-ai-cloud/axolotl/blob/main/examples/llama-3/qlora-fsdp-405b.yaml

https://axolotl-ai-cloud.github.io/axolotl/docs/dataset-formats/#conversation-dataset

https://github.com/axolotl-ai-cloud/axolotl/blob/860609392184cf62a7e0ca676658b170e059ce6c/src/axolotl/utils/chat_templates.py#L17

https://huggingface.co/docs/transformers/en/model_doc/auto#transformers.AutoModelForCausalLM
https://web.archive.org/web/20250321024154/https://huggingface.co/docs/transformers/en/model_doc/auto#transformers.AutoModelForCausalLM
https://huggingface.co/docs/transformers/v4.50.0/en/model_doc/llama#transformers.LlamaForCausalLM
https://web.archive.org/save/https://huggingface.co/docs/transformers/v4.50.0/en/model_doc/llama#transformers.LlamaForCausalLM
https://huggingface.co/docs/transformers/en/model_doc/auto#transformers.AutoTokenizer
https://web.archive.org/web/20250321024154/https://huggingface.co/docs/transformers/en/model_doc/auto#transformers.AutoTokenizer
https://huggingface.co/docs/transformers/v4.50.0/en/model_doc/llama#transformers.LlamaConfig
https://web.archive.org/web/20250403113221/https://huggingface.co/docs/transformers/v4.50.0/en/model_doc/llama#transformers.LlamaConfig

https://www.reddit.com/r/LocalLLaMA/comments/18pk6wm/how_to_qlora_fine_tune_using_axolotl_zero_to/
 'new "merged" folder in the output folder'

https://medium.com/about-ai/how-to-fine-tune-llms-with-axolotl-41ad5d2bc569
https://axolotlai.substack.com/p/fine-tuning-llama-31b-waxolotl-on
https://medium.com/@wasifmehmood/finetuning-llms-using-axolotl-with-qlora-9e0188866bab


https://axolotl-ai-cloud.github.io/axolotl/docs/inference.html





https://github.com/ggml-org/llama.cpp/blob/master/docs/docker.md

https://www.animal-machine.com/posts/fine-tuning-llama-models-with-qlora-and-axolotl/
 'Setup llama.cpp for quantization and inference '

https://medium.com/@qdrddr/the-easiest-way-to-convert-a-model-to-gguf-and-quantize-91016e97c987
https://medium.com/@kevin.lopez.91/simple-tutorial-to-quantize-models-using-llama-cpp-from-safetesnsors-to-gguf-c42acf2c537d
https://towardsdatascience.com/quantize-llama-models-with-ggml-and-llama-cpp-3612dfbcc172/






https://gist.github.com/cedrickchee/6e9cff188d24a5b4429af1845f912688






https://github.com/axolotl-ai-cloud/axolotl/discussions/2280

