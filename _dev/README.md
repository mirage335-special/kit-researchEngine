
Developer documentation concerning additional refining (ie. training) of AI LLM text models for developer purposes.

Two AI LLM models and associated refinement datasets in particular are recommended as well:
Llama-tech-405b (REASONING, scientific knowledge, programming knowledge, programming logic, programming documentation - eg. call graphs, development task model - ie. web query generation, merge Many-Chat, additional voice contribution to automation, natural language user interfaces)
Llama-augment (INSTRUCT, small, fast, embedded uses)

For coordinating storage, builds, downloads, etc, for these models/datasets, a 'Llama-tech' repository may exist, possibly available through GitHub and ubdist/OS.

If not, various scratch (ie. scratchpad) text files in the 'researchEngine' repository will provide the necessary commands to run within an adequate context (ie. bash with '_setupUbiquitous' having loaded the necessary 'ubiquitous_bash' functions including '_getAbsoluteLocation' in the environment).

Model files and such can be kept in a project subdirectory dedicated to routine zero-infrastructure manual binary builds.
```
[___quick]'/project/zFactory/'Llama-tech
```


Strongly discouraged: do NOT substitute the 405b model for lower parameter count. Claimed benefits of the newer 70b model only apply to some use cases - accuracy and helpfulness in most use developer or technical cases remain very substantially better for Llama 405b .
Strongly discouraged: do NOT substitute the 8b model for a lower parameter count. Models much smaller than this tend to have very severe deficiencies for all plausible use cases.
These are points of diminishing returns, below which, smaller model counts are not normally worthwhile.

Llama 3.1 and ChatGPT's largest models (o1-pro, 4.5-preview) have different gaps in technical knowledge and reasoning. Other AI models, including newer AI models have the gaps of both those models and much more severe gaps. Newer versions of Llama (ie. Llama 3.3) have not yet shown a compelling differentiator over Llama 3.1 . The same is also true of Llama 3.1 fine-tunes and merges that do not directly address a substantial deficiency in the training set (ie. absence or lack of prominence of 'ubiquitous_bash' quality shell-code as examples) - Daredevil8b and Daredevil8b-abliterated have not been comprehensively evaluated for useful technical knowledge (eg. plasma recombination photon emission physics) and reasoning (eg. shell coding).


# Plans

As a reminder, '_plan' files are partial AI prompts to fill in with information to provide context for getting AI LLM assistance. AI LLMs are especially effective for scruitinizing loging output at the verbosity of axolotl , etc.


# Inference

Serverless vLLM hosts are suggested for 405b models.


# Corpus Generation

Functions to generate usable segments of code from large code files (eg. '.sh' files) are available from 'ubiquitous_bash' (eg. _corpus_bash-write ).


# Corpus Conversion

Corpus of scientific knowledge, programming code, may be converted to realistic tell-me-about-this-keyword prompt/response pairs, write-code-to-match-this-description, as well as realistic 'continue' (aka. 'pre-training') complete-the-sentence continue_prompt/continue_response pairs with the 'helpful' header/footer added by INSTRUCT, etc, trained AI models. Such techniques are much less crude than continuing pre-training with raw text, avoiding overfitting 'base' responses reverting the helpfulness of INSTRUCT, etc, trained AI models, as well as improving compatibility with fine-tuning software.

Such more realistic datasets can be generated very quickly (less than hours) and cheaply (less than a few dollars at high-throughput per few megabytes of examples), and are expected better for all purposes except initial training of a completely untrained AI model.

Prompts and code to do this, as well as to create the more familiar crude 'next token' text datasets, are a very major part of the 'ubiquitous_bash' project. Please find the 'ubiquitous_bash/ai/dataset/convert' directory, especially the file 'here_convert.sh' containing prompts.


# Corpus Training on Code

Large number of epochs may be appropriate for training LLMs to have knowledge of correct commands from long shell scripts (theoretically - to intentionally overfit the complete, correct commands from single examples).


# Chain-Of-Reasoning

Chain-of-Reasoning may be taught to  Llama-tech-405b  using DeepSeek R1 (MIT licensed) models (eg. DeepSeek R1, DeepSeek R1 Distill Llama 70b). Chain-Of-Reasoning does seem much more sensitive to quantization and parameter counts much below ~32b .

However, the disadvantages of chain-of-reasoning - higher imposed latency on responses from a 405b model with more affordable hardware, much worse sensitivity to quantization, fundamentally worse accuracy and completeness of outputs from good prompts - could theoretically be avoided by adding a chain-of-reasoning model to the conversation, and using a ~32b or 70b model for such a purpose at that.


# Common Semantics

Commonality of refining/training dataset with typical internet, etc, trained LLM output semantics is STRONGLY SUGGESTED to the extent possible. Hopefully, such similarlity will minimize the difference needed in model weights, hopefully such smaller changes will have greater effects.

Prompt engineering should account for this carefully, chosing semantics both familiar to AI LLMs, yet with appropriate conceptual spacing to avoid apparent cross-talk between concepts. Negative prompting can drastically reduce error rates, but must be very careful to avoid broadly suppressing entire categories or sizes of output. Repeated manual unit-testing is strongly encouraged.


# Developer and Automation Models

Developer models (eg. Llama-tech-405b), also useful as an extra voice to catch problems in real-time for automation, need large parameter counts, etc, to at least sometimes generate accurate complex results. Not every result must be usuable - some random variations and failure sare tolerable for developer use. Since such models are directly used by developers, and in some use cases possibly also end-users (eg. natural language interfaces to control machinery), at least an inherent tendency to avoid unpleasant output should be desirable. Refinement to create such models does NOT necessarily (and more than probably should NOT) begin with an 'abliterated' model.

Automation models (eg. Llama-augment) often cannot afford error rates beyond parts-per-thousand if not less, or failing to remember previous prompts, or sensitivity to as much quantization as possible for speed and archival preservation (ie. optical disc). Refinement to create such models SHOULD begin with an 'abliterated' Llama 3.1 model.


# Commands - Downloading Hugging Face Repositories

Beware these commands can be slow, with little CPU, disk, or network usage (especially true of  git reset --hard  ), yet still correctly unpacking the resulting 'git lfs' repository.

git lfs install
git clone --recursive https://huggingface.co/NousResearch/Llama-3.2-1B

cd ./Llama-3.2-1b
du -sh .git
git lfs fetch
git lfs checkout
git reset --hard



# Reference

https://www.youtube.com/watch?v=rpAtVIZB72U&t=420s
 'LLAMA-3.1' 'FINE-TUNE'
 DUBIOUS. Possibly usefully so. Shows example code and diagnostic outputs from Unsloth in some detail.

https://www.youtube.com/watch?v=Ucg1X_o1HDE&t=1020s
 'Finetuning Llama 3.1 to talk like Rick Sanchez | Unsloth Tutorial'
 Briefly shows some Unsloth diagnostic output.

https://www.youtube.com/watch?v=pxhkDaKzBaY&t=60s
 'Fine-Tune a LLM' 'Use it with Ollama'
 Apparently shows the Ollama Modelfile and such used for an Unsloth fine tuned model.

https://www.youtube.com/watch?v=lj44Bt9UxYQ
 'Axolotl is a AI FineTuning Magician'
 'When I used just the install that's on the website, almost nothing worked. And I had endless errors with mismatched versions and it was just a mess. Let's start by creating the environment using'
 'conda create -n ax python=3.11'
 'conda activate ax'
 'conda install pytorch torchvision torchaudio pytorch-cuda -c pytorch -c nvidia'
 'git clone https://github.com/axolotl-ai-cloud/axolotl.git/axolotl'
 'pip install packaging'
 'pip install -e '.[flash-attn,deepspeed]'
 'pip install -U git+https://github.com/huggingface/peft.git'
 'pip install --upgrade "jinja2>=3.1.0"

"Llama-3.1" "See axolotl config" site:huggingface.co
https://huggingface.co/axolotl-ai-co/finetome-llama-3.1-70b
 'finetome'
https://huggingface.co/minionai/llama_3.1_70b_cove_prod_81424_amazon_filt_merged
https://huggingface.co/pbevan11/llama-3.1-8b-ocr-correction
https://huggingface.co/ericflo/Llama-3.1-SyntheticPython-405B-Base-LoRA
https://huggingface.co/SE6446/Llama-3.1-SuperNova-Lite-Reflection-V1.0
 'model appears to perform adequatel'
 'Loss: 0.6365'
 'must use the tokenizer provided with the model as the COT tokens are unique special tokens'
 'should work on most inference engines that can run llama 3.1'
  '2.7211	0.0049	1	1.4048
   0.6381	0.5	103	0.6583
   0.4985	1.0049	206	0.6320
   0.4992	1.5049	309	0.6365'
https://huggingface.co/femT-data/llama-3.1-8B-instruct-GNER
https://huggingface.co/suayptalha/EmojiLlama-3.1-8B
https://huggingface.co/winglian/llama-3.1-8b-math-r1
https://huggingface.co/jplhughes2/1a_meta-llama-Llama-3.1-405B-Instruct-fsdp
https://huggingface.co/VoyagerYuan/Xillama-3.1-405B-Instruct-BNB-NF4-BF16-Writer
https://huggingface.co/axolotl-ai-co/numina-70b-ep3-lr1e-5-sft-lora
https://huggingface.co/anthracite-org/magnum-v2-4b






https://arxiv.org/abs/2305.14314
 'QLoRA: Efficient Finetuning of Quantized LLMs'

https://www.anyscale.com/blog/fine-tuning-llms-lora-or-full-parameter-an-in-depth-analysis-with-llama-2

https://www.theregister.com/2024/11/10/llm_finetuning_guide/?page=6
 'Optimizer' 'Usually this is going to be Adam, AdamW, or adamw_bnb_8bit. The latter uses quantization to load the optimizer states at 8-bit precision, which reduces the memory footprint required to fine-tune the model.'
 'lora_r' 'Defines how large the LoRA matrices used to train the model are and by extension, how many weights are ultimately updated. The larger the rank, the more weights that get fine-tuned.'
 'lora_alpha' 'In our research, we found that practice appears to be to set lora_alpha to around a fourth lora_rank. So if lora_r is set to 64, lora_alpha should be set to 16.'
 'lora_dropout' '0.05 was effective for smaller models in the 7 to 13 billion parameter range'






https://huggingface.co/docs/transformers/en/model_doc/auto#transformers.AutoModelForCausalLM
https://huggingface.co/docs/transformers/v4.50.0/en/model_doc/llama#transformers.LlamaForCausalLM
https://huggingface.co/docs/transformers/en/model_doc/auto#transformers.AutoTokenizer
https://huggingface.co/docs/transformers/v4.50.0/en/model_doc/llama#transformers.LlamaConfig





https://github.com/ollama/ollama/blob/main/docs/import.md





https://ollama.com/library/llama3.1:405b-instruct-fp16
 'ollama run llama3.1:405b-instruct-fp16'
  ollama pull llama3.1:405b-instruct-fp16

https://huggingface.co/meta-llama/Llama-3.1-405B-Instruct

https://github.com/axolotl-ai-cloud/axolotl/blob/main/examples/llama-3/qlora-fsdp-405b.yaml
https://huggingface.co/hugging-quants/Meta-Llama-3.1-405B-BNB-NF4-BF16
 'In order to run the inference with Llama 3.1 405B BNB in NF4, around 220 GiB of VRAM are needed only for loading the model checkpoint, without including the KV cache or the CUDA graphs, meaning that there should be a bit over that VRAM available.'
  '220 GiB of VRAM'



https://github.com/soaringDistributions/Llama-augment_bundle
https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated
https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF
 STRONGLY RECOMMENDED - Begin 'Llama-augment' refinement from 'mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated' model .



https://huggingface.co/posts/mlabonne/714992455492422
https://web.archive.org/web/20250323031549/https://huggingface.co/posts/mlabonne/714992455492422
https://colab.research.google.com/drive/1RmLv-pCMBBsQGXQIM8yF-OdCNyoylUR1?usp=sharing
 'AutoAbliteration'

https://huggingface.co/blog/mlabonne/abliteration
https://web.archive.org/web/20250328094845/https://huggingface.co/blog/mlabonne/abliteration
 'additional training allowed us to recover most of the performance drop due to abliteration'





https://www.reddit.com/r/LocalLLaMA/comments/1e6u031/llama3_8bs_performance_on_rtx_4090_gpu/
https://medium.com/@marketing_novita.ai/riding-the-lightning-llama3-8bs-performance-on-the-cutting-edge-rtx-4090-gpu-797153ee1762










