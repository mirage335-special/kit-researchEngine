
Essential information to operate 'Llama-tech' factory .
```
[___quick]'/project/zFactory/'Llama-tech
```

Inference directly from unsloth, unlike ollama, etc, may depend somewhat on 'max_new_tokens', however, for such a reasonable value as 'max_new_tokens = 64', output should be sane and NOT gibberish.



# Certification

Apparently able to create sane output NOT gibberish fine tuned AI models:


## 2025-05-14

Factory Docker containers built somewhat recently as of 2025-05-14 .
https://github.com/orgs/mirage335-colossus/packages?repo_name=ubiquitous_bash



# Scrap - Install unsloth

More recent commands may be available:
.../ubiquitous_bash/shortcuts/factory/factoryCreate.sh
.../ubiquitous_bash/shortcuts/factory/factoryCreate_here.sh

Particularly, STRONGLY RECOMMENDED to use 'unsloth==2025.4.7' , Python12, or other version specifications from:
https://github.com/unslothai/unsloth/releases
https://github.com/unslothai/unsloth

There have been apparent issues with other unsloth versions, dependency issues with unsloth version specifications used by various tutorials, and reportedly (per unsloth README) 'Python 3.13 does not support Unsloth' .

ALWAYS specify, versions, etc, in example documentation, etc. Preserve output from 'pip freeze' if useful .


```bash
# https://github.com/unslothai/unsloth   (2025-05-07)
#  'Python 3.12'
RUN python -m pip uninstall -y torch torchvision torchaudio triton unsloth unsloth_zoo xformers sympy mpmath
RUN apt-get update -y
RUN apt-get install libcurl4-openssl-dev -y
RUN apt-get install python3.12 -y
RUN apt-get install python3.12-dev -y
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
RUN update-alternatives --config python3
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1
RUN update-alternatives --config python
RUN curl -sS https://bootstrap.pypa.io/get-pip.py -o - | python3
RUN python3 -m pip install --upgrade pip
RUN python -m pip uninstall -y torch torchvision torchaudio triton unsloth unsloth_zoo xformers sympy mpmath
#
#RUN pip install "unsloth"
#RUN pip install --upgrade --force-reinstall --no-cache-dir unsloth unsloth_zoo

# https://github.com/unslothai/unsloth/releases
pip install --upgrade --force-reinstall "unsloth==2025.4.7" unsloth_zoo
```


# Scrap - Inference

https://github.com/unslothai/unsloth/wiki
https://colab.research.google.com/github/unslothai/notebooks/blob/main/nb/Llama3.1_(8B)-Alpaca.ipynb#scrollTo=kR3gIAX-SM2q

```python
from unsloth import FastLanguageModel
from transformers import AutoTokenizer, AutoModelForCausalLM, TextStreamer

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name = "unsloth/Meta-Llama-3.1-8B", # YOUR MODEL YOU USED FOR TRAINING
    max_seq_length = max_seq_length,
    dtype = dtype,
    load_in_4bit = load_in_4bit,
)

#Is 9.11 larger than 9.9?


FastLanguageModel.for_inference(model) # Enable native 2x faster inference

inputs = tokenizer(
[
    alpaca_prompt.format(
        "Continue the fibonnaci sequence.", # instruction
        "1, 1, 2, 3, 5, 8", # input
        "", # output - leave this blank for generation!
    )
], return_tensors = "pt").to("cuda")

outputs = model.generate(**inputs, max_new_tokens = 64, use_cache = True)
tokenizer.batch_decode(outputs)

text_streamer = TextStreamer(tokenizer)
_ = model.generate(**inputs, streamer = text_streamer, max_new_tokens = 64)



inputs = tokenizer(
[
    alpaca_prompt.format(
        "Answer the question.", # instruction
        "Is 9.11 larger than 9.9?", # input
        "", # output - leave this blank for generation!
    )
], return_tensors = "pt").to("cuda")


text_streamer = TextStreamer(tokenizer)
_ = model.generate(**inputs, streamer = text_streamer, max_new_tokens = 64)



inputs = tokenizer(
[
    alpaca_prompt.format(
        "Try to be helpful. Answer the question, perform the task, etc.", # instruction
        "Please write a short story.", # input
        "", # output - leave this blank for generation!
    )
], return_tensors = "pt").to("cuda")


text_streamer = TextStreamer(tokenizer)
_ = model.generate(**inputs, streamer = text_streamer, max_new_tokens = 64)



```


# Scrap - Quantization

```bash
apt-get install libcurl4-openssl-dev -y

```

```python
model.save_pretrained_gguf("/workspace/", tokenizer, quantization_method = "q4_k_m")

```

```python
# ATTRIBUTION-AI: ChatGPT o3  2025-05-08
from unsloth.chat_templates import get_chat_template   # NEW import

# … your FastLanguageModel.from_pretrained() block …

# tell Unsloth which template to graft onto the tokenizer
tokenizer = get_chat_template(
    tokenizer,
    chat_template="llama",      # works for every *Llama‑3.x* repo
    # or "alpaca" if you really want the simple Alpaca prompt style
)

# now this succeeds
print(tokenizer._ollama_modelfile)

```

```bash
ollama create finellama-q4km -f Modelfile
```


# Scrap - Quantization - push HuggingFace

```python
# ATTRIBUTION-AI: ChatgPT o3 2025-05-03
from huggingface_hub import login   # pip install -U huggingface_hub
login(token="hf_XXXXXXXXXXXXXXXXXXXXXXXX")   # paste your write‑token here

```

```python
quant_methods = ["q2_k", "q3_k_m", "q4_k_m", "q5_k_m", "q6_k", "q8_0"]
for quant in quant_methods:
    model.push_to_hub_gguf("user/FineLlama-3.1-8B-GGUF", tokenizer, quant)

```


# Scrap - Example

https://github.com/unslothai/unsloth?tab=readme-ov-file#-documentation
https://github.com/unslothai/unsloth/releases
https://colab.research.google.com/github/unslothai/notebooks/blob/main/nb/Llama3.1_(8B)-Alpaca.ipynb
https://colab.research.google.com/github/unslothai/notebooks/blob/main/nb/Llama3_(8B)-Ollama.ipynb

Example code is provided . But with issues - inconsistencies including FastModel (multi-modal) and FastLanguageModel (text-only) with some examples specifying a stanza of code from before such functionality was split, some examples specifying a stanza of code after.


# Scratch - Example

```python
from unsloth import FastLanguageModel
import torch

max_seq_length = 2048 # Choose any! We auto support RoPE Scaling internally!
dtype = None # None for auto detection. Float16 for Tesla T4, V100, Bfloat16 for Ampere+
load_in_4bit = True # Use 4bit quantization to reduce memory usage. Can be False.

# 4bit pre quantized models we support for 4x faster downloading + no OOMs.
fourbit_models = [
    "unsloth/Meta-Llama-3.1-8B-bnb-4bit",      # Llama-3.1 15 trillion tokens model 2x faster!
    "unsloth/Meta-Llama-3.1-8B-Instruct-bnb-4bit",
    "unsloth/Meta-Llama-3.1-70B-bnb-4bit",
    "unsloth/Meta-Llama-3.1-405B-bnb-4bit",    # We also uploaded 4bit for 405b!
    "unsloth/Mistral-Nemo-Base-2407-bnb-4bit", # New Mistral 12b 2x faster!
    "unsloth/Mistral-Nemo-Instruct-2407-bnb-4bit",
    "unsloth/mistral-7b-v0.3-bnb-4bit",        # Mistral v3 2x faster!
    "unsloth/mistral-7b-instruct-v0.3-bnb-4bit",
    "unsloth/Phi-3.5-mini-instruct",           # Phi-3.5 2x faster!
    "unsloth/Phi-3-medium-4k-instruct",
    "unsloth/gemma-2-9b-bnb-4bit",
    "unsloth/gemma-2-27b-bnb-4bit",            # Gemma 2x faster!
] # More models at https://huggingface.co/unsloth

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name = "unsloth/Meta-Llama-3.1-8B",
    max_seq_length = max_seq_length, # Choose any! We auto support RoPE Scaling internally!
    dtype = dtype, # None for auto detection. Float16 for Tesla T4, V100, Bfloat16 for Ampere+
    load_in_4bit = load_in_4bit,
    load_in_8bit = False, # [NEW!] A bit more accurate, uses 2x memory
    full_finetuning = False, # [NEW!] We have full finetuning now!
    # token = "hf_...", # use one if using gated models like meta-llama/Llama-2-7b-hf
)

model = FastLanguageModel.get_peft_model(
    model,
    r = 16, # Choose any number > 0 ! Suggested 8, 16, 32, 64, 128
    target_modules = ["q_proj", "k_proj", "v_proj", "o_proj",
                      "gate_proj", "up_proj", "down_proj",],
    lora_alpha = 16,
    lora_dropout = 0, # Supports any, but = 0 is optimized
    bias = "none",    # Supports any, but = "none" is optimized
    # [NEW] "unsloth" uses 30% less VRAM, fits 2x larger batch sizes!
    use_gradient_checkpointing = "unsloth", # True or "unsloth" for very long context
    random_state = 3407,
    max_seq_length = max_seq_length,
    use_rslora = False,  # We support rank stabilized LoRA
    loftq_config = None, # And LoftQ
)






alpaca_prompt = """Below is an instruction that describes a task, paired with an input that provides further context. Write a response that appropriately completes the request.

### Instruction:
{}

### Input:
{}

### Response:
{}"""

EOS_TOKEN = tokenizer.eos_token # Must add EOS_TOKEN
def formatting_prompts_func(examples):
    instructions = examples["instruction"]
    inputs       = examples["input"]
    outputs      = examples["output"]
    texts = []
    for instruction, input, output in zip(instructions, inputs, outputs):
        # Must add EOS_TOKEN, otherwise your generation will go on forever!
        text = alpaca_prompt.format(instruction, input, output) + EOS_TOKEN
        texts.append(text)
    return { "text" : texts, }

pass

from datasets import load_dataset
dataset = load_dataset("yahma/alpaca-cleaned", split = "train")
dataset = dataset.map(formatting_prompts_func, batched = True,)








from trl import SFTTrainer
from transformers import TrainingArguments
from unsloth import is_bfloat16_supported


trainer = SFTTrainer(
    model = model,
    tokenizer = tokenizer,
    train_dataset = dataset,
    dataset_text_field = "text",
    max_seq_length = max_seq_length,
    dataset_num_proc = 2,
    packing = False, # Can make training 5x faster for short sequences.
    args = TrainingArguments(
        per_device_train_batch_size = 2,
        gradient_accumulation_steps = 4,
        warmup_steps = 5,
        # num_train_epochs = 1, # Set this for 1 full training run.
        max_steps = 60,
        learning_rate = 2e-4,
        fp16 = not is_bfloat16_supported(),
        bf16 = is_bfloat16_supported(),
        logging_steps = 1,
        optim = "adamw_8bit",
        weight_decay = 0.01,
        lr_scheduler_type = "linear",
        seed = 3407,
        output_dir = "outputs",
        report_to = "none", # Use this for WandB etc
    ),
)


trainer.train()




# Go to https://github.com/unslothai/unsloth/wiki for advanced tips like
# (1) Saving to GGUF / merging to 16bit for vLLM
# (2) Continued training from a saved LoRA adapter
# (3) Adding an evaluation loop / OOMs
# (4) Customized chat templates

```






