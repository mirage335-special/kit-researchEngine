
Former effort to begin AI LLM fine tuning pipeline with axolotl , hoping to outsource maintenance, initial config, portability, etc, to the seemingly versatile axolotl framework.

Unfortunately it seems, examples of axolotl fine tuning are very common, but examples of outputs from a llama3 model after axolotl fine tuning are rare to nonexistent. Although the official getting started begins with llama-3.2-1b qlora fine tuning, resulting output of such fine tuned models is more than mostly gibberish. Searching through axolotl github issues and attempting to reduce the strength of lora training was not promising.

Example configuration files from the axolotl project could be intended as placeholders awaiting work to adapt code examples to their config file format.


Some of the documentation, etc, regarding axolotl, may still include some necessary bits of information to achieve results with other techniques, thus salvaged here.



# Reference


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

