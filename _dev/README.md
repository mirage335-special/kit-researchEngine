
Developer documenation, mostly if not entirely concerning additional refining (ie. training) of two AI LLM models:
Llama-tech-405b (REASONING, scientific knowledge, programming knowledge, programming logic, programming documentation - eg. call graphs, development task model - ie. web query generation, merge Many-Chat)
Llama-augment (INSTRUCT, small, fast, embedded uses)

Do NOT substitute the 405b model for lower parameter count - accuracy and helpfulness are very substantially better.


IMPORTANT:

Corpus of scientific knowledge may be possible to convert to prompt/response pairs by generating questions based on keywords, titles, etc. In addition to better aligning with prompt/response dataset JSONL formats, without blank prompt or response, or recursively generated prompt/response splitting, this may or may not improve the ability of the AI LLM model to integrate this knowledge within general-purpose knwoledge and reasoning (possibly answering scientific questions better).


ATTENTION:

Chain-of-reasoning may be taught to  Llama-tech-405b  using DeepSeek R1 (MIT licensed) models (eg. DeepSeek R1, DeepSeek R1 Distill Llama 70b).

Commonality of refining/training dataset with typical internet, etc, trained LLM output semantics is STRONGLY SUGGESTED to the extent possible. Hopefully, such similarlity will minimize the difference needed in model weights, hopefully such smaller changes will have greater effects.

Large number of epochs may be appropriate for training LLMs to have knowledge of correct commands from long shell scripts (theoretically - to intentionally overfit the complete, correct commands from single examples).


NOTICE:

Refined  Llama-tech-405b  model does NOT necessarily (and more than probably should NOT) begin with 'abliterated' model, due to both the improved parameter count, and also possibly end-user (or nearly such) applications. However, generating training data (ie. converting corpus to prompt/response pairs) may REQUIRE an 'abliterated' model to avoid greatly overfitting inappropriate dialogue around professionally written programming code which should already be following best practices for remaining non-controversial. A consistent message repeated a small number of times (eg. less than 50 times total) in fine-tuning training data can induce drastically fewer (ie. almost never) correct responses.

Llama-augment model  SHOULD begin with an 'abliterated' Llama 3.1 model, for apparently improved compliance, remembering previous prompts, knowledge, etc.

Refining/training the  Llama-augment  model can theoretically be used to experimentally validate datasets before attempting to train  Llama-tech-405b .



# Installation - Axolotl

docker run --gpus '"all"' --rm -it axolotlai/axolotl:main-latest

TODO: Install 'ubiquitous_bash' within 'axolotl' Docker container for Llama-augment scripting, bash 'ollama' scripting, etc (eg. of creating JSONL prompt/response pairs from code, etc).




# Scrap

ATTRIBUTION-AI: ChatGPT 4.5-preview Deep Research  2025-03-30  (WARNING: DUBIOUS)

...

pretraining_dataset:
  - path: text            # Use Hugging Face "text" loader for raw text
    data_files:
      - data/my_corpus.txt      # Path to your text file
      # - data/other_corpus.txt # (You can list multiple .txt files if needed)
# ... other training config options ...
sequence_len: 2048         # example context length
max_steps: 10000           # must specify when streaming (no fixed epoch)&#8203;:contentReference[oaicite:2]{index=2}


... alternative


datasets:
  - path: data/my_corpus.txt   # Direct path to the .txt file
    ds_type: text              # Explicitly declare raw text format (optional if ".txt" in path)
    type: completion           # Treat each entry as a plain text completion (no prompt)
    train_on_split: train      # Use the 'train' split (default when loading a single file)
# ... other config (model, training params, etc) ...


... equivalent

load_dataset("text", data_files={"train": ["data/my_corpus.txt"]})

...

'By default, each line in the .txt is one training example. If your file has multiple lines making up one logical document, you may want to combine them or split by paragraphs. Hugging Face’s text loader supports a sample_by parameter (e.g. "paragraph" or "document")​
HUGGINGFACE.CO
, but Axolotl’s YAML interface doesn’t expose this directly. In practice, if you need custom splitting (e.g. splitting a long text into 3000-token chunks), you should pre-process the file accordingly (see below).'

'JSONL' 
'explicitly labels the content field (e.g. "text"), which Axolotl looks for by default in completion mode​'










# Reference

https://github.com/axolotl-ai-cloud/axolotl/tree/main?tab=readme-ov-file
https://axolotl-ai-cloud.github.io/axolotl/docs/installation.html



https://ollama.com/library/llama3.1:405b-instruct-fp16
 'ollama run llama3.1:405b-instruct-fp16'
  ollama pull llama3.1:405b-instruct-fp16

https://huggingface.co/meta-llama/Llama-3.1-405B-Instruct

https://github.com/axolotl-ai-cloud/axolotl/blob/main/examples/llama-3/qlora-fsdp-405b.yaml
https://huggingface.co/hugging-quants/Meta-Llama-3.1-405B-BNB-NF4-BF16
 'In order to run the inference with Llama 3.1 405B BNB in NF4, around 220 GiB of VRAM are needed only for loading the model checkpoint, without including the KV cache or the CUDA graphs, meaning that there should be a bit over that VRAM available.'
  '220 GiB of VRAM'



https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated
https://huggingface.co/mlabonne/Meta-Llama-3.1-8B-Instruct-abliterated-GGUF

https://github.com/soaringDistributions/Llama-augment_bundle



https://huggingface.co/posts/mlabonne/714992455492422
https://colab.research.google.com/drive/1RmLv-pCMBBsQGXQIM8yF-OdCNyoylUR1?usp=sharing
 'AutoAbliteration'



https://docs.runpod.io/fine-tune/
 'huggingface-cli login'
 'huggingface-cli upload <your-username>/<model-name> ./output'
   Presumably download as well.




https://github.com/axolotl-ai-cloud/axolotl/discussions/1546
 'jsoln'

https://axolotl-ai-cloud.github.io/axolotl/docs/dataset-formats/

https://huggingface.co/docs/datasets/en/nlp_load
 'Load text data'











