
Essential information to operate 'Llama-tech' factory .
```
[___quick]'/project/zFactory/'Llama-tech
```

# Scratch

```python
# ATTRIBUTION-AI: ChatgPT o3 2025-05-03
from huggingface_hub import login   # pip install -U huggingface_hub
login(token="hf_XXXXXXXXXXXXXXXXXXXXXXXX")   # paste your write‑token here
```

```python
quant_methods = ["q2_k", "q3_k_m", "q4_k_m", "q5_k_m", "q6_k", "q8_0"]
for quant in quant_methods:
    model.push_to_hub_gguf("mirage335/FineLlama-3.1-8B-GGUF", tokenizer, quant)

```




# ubiquitous_bash

```bash
# ###

if [[ -e /workspace/ubiquitous_bash/ubiquitous_bash.sh ]]
then
( cd /workspace/ubiquitous_bash ; /workspace/ubiquitous_bash/ubiquitous_bash.sh _gitBest pull ; git submodule update )
/workspace/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous_nonet
export profileScriptLocation="/workspace/ubiquitous_bash/ubiquitous_bash.sh"
export profileScriptFolder="/workspace/ubiquitous_bash"
. "/workspace/ubiquitous_bash/ubiquitous_bash.sh" --profile _importShortcuts
else
mkdir -p /workspace
! [[ -e /workspace/ubiquitous_bash.sh ]] && wget 'https://raw.githubusercontent.com/mirage335/ubiquitous_bash/master/ubiquitous_bash.sh'
mv -f ./ubiquitous_bash.sh /workspace/ubiquitous_bash.sh
chmod u+x /workspace/ubiquitous_bash.sh
rmdir /workspace/ubiquitous_bash > /dev/null 2>&1
/workspace/ubiquitous_bash.sh _gitBest clone --depth 1 --recursive git@github.com:mirage335-colossus/ubiquitous_bash.git
mv -f ./ubiquitous_bash /workspace/ubiquitous_bash
mkdir -p /workspace/ubiquitous_bash
! [[ -e /workspace/ubiquitous_bash/ubiquitous_bash.sh ]] && wget 'https://raw.githubusercontent.com/mirage335/ubiquitous_bash/master/ubiquitous_bash.sh'
mv -f ./ubiquitous_bash.sh /workspace/ubiquitous_bash/ubiquitous_bash.sh
chmod u+x /workspace/ubiquitous_bash/ubiquitous_bash.sh
/workspace/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous_nonet
( cd ~/.ubcore/ubiquitous_bash ; ~/.ubcore/ubiquitous_bash/ubiquitous_bash.sh _gitBest pull ; git submodule update )
fi
true
#clear

# DISCOURAGED. Better to benefit from 'ubiquitous_bash' maintenance identifying the most recent ollama installation commands. 
#curl -fsSL https://ollama.com/install.sh | sh
# DISCOURAGED. Does NOT install Llama-augment model.
/workspace/ubiquitous_bash/ubiquitous_bash.sh _setup_ollama_sequence
# PREFERRED. Normally robust, resilient, maintained, and adds the 'Llama-augment' model for automation, etc.
#/workspace/ubiquitous_bash/ubiquitous_bash.sh _setup_ollama

# ###
```

# Init

```bash
# https://huggingface.co/blog/mlabonne/sft-llama3
# https://colab.research.google.com/drive/164cg_O7SV7G8kZr_JXqLd6VC7pd86-1Z?usp=sharing
# https://huggingface.co/blog/mlabonne/merge-models

# ATTRIBUTION-AI: Some suggestions from  Llama 3.1 Nemotron Utra 253b v1  2025-04-30 .

export PYTORCH_ENABLE_MKLDNN_FALLBACK=1  # Optional, for MKL-DNN fallback
export TORCH_CACHE="/workspace/cache_torch"
export PIP_CACHE_DIR="/workspace/cache_pip"
export PYTHONNOUSERSITE=True  # Avoid using user site-packages
export XDG_CACHE_HOME="/workspace/cache_xdg"  # For general cache (e.g., pip, setuptools)
mkdir -p "$TORCH_CACHE" "$PIP_CACHE_DIR" "$XDG_CACHE_HOME"

apt-get update
apt upgrade -y
apt-get install sudo -y

python -m pip install --upgrade pip --cache-dir "$PIP_CACHE_DIR"


#apt-get install python3.10 python3.10-dev python3.10-distutils -y
#update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
#update-alternatives --config python3

#curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3
#python -m pip install --upgrade pip --cache-dir "$PIP_CACHE_DIR"
#python -m pip install --upgrade pip setuptools wheel --cache-dir "$PIP_CACHE_DIR"



#python -m pip uninstall -y torch torchvision torchaudio triton unsloth unsloth_zoo xformers sympy mpmath

#python -m pip install --upgrade pip --cache-dir "$PIP_CACHE_DIR"

#"unsloth @ git+https://github.com/unslothai/unsloth.git"
#pip install "unsloth[colab-new] @ git+https://github.com/unslothai/unsloth.git" --cache-dir "$PIP_CACHE_DIR"
#PIP_PREFER_BINARY=1 pip install --prefer-binary --no-build-isolation "unsloth[cu121-torch230]"
#pip install "unsloth"


# https://colab.research.google.com/drive/164cg_O7SV7G8kZr_JXqLd6VC7pd86-1Z?usp=sharing
# runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04
pip install "unsloth[colab-new] @ git+https://github.com/unslothai/unsloth.git" --cache-dir "$PIP_CACHE_DIR"

```


# Fine Tuning (unsloth)

```bash
# https://huggingface.co/blog/mlabonne/sft-llama3 
# https://colab.research.google.com/drive/164cg_O7SV7G8kZr_JXqLd6VC7pd86-1Z?usp=sharing
# https://huggingface.co/blog/mlabonne/merge-models
mkdir -p /workspace
cd /workspace
clear ; python

```

```python
import unsloth

import torch
from trl import SFTTrainer
from datasets import load_dataset
from transformers import TrainingArguments, TextStreamer

from unsloth.chat_templates import get_chat_template
from unsloth import FastLanguageModel, is_bfloat16_supported

# ###


max_seq_length = 2048
model, tokenizer = FastLanguageModel.from_pretrained(
    model_name="unsloth/Meta-Llama-3.1-8B-bnb-4bit",
    max_seq_length=max_seq_length,
    load_in_4bit=True,
    dtype=None,
)

model = FastLanguageModel.get_peft_model(
    model,
    r=16,
    lora_alpha=16,
    lora_dropout=0,
    target_modules=["q_proj", "k_proj", "v_proj", "up_proj", "down_proj", "o_proj", "gate_proj"], 
    use_rslora=True,
    use_gradient_checkpointing="unsloth"
)


# ###


tokenizer = get_chat_template(
    tokenizer,
    mapping={"role": "from", "content": "value", "user": "human", "assistant": "gpt"},
    chat_template="chatml",
)

def apply_template(examples):
    messages = examples["conversations"]
    text = [tokenizer.apply_chat_template(message, tokenize=False, add_generation_prompt=False) for message in messages]
    return {"text": text}

dataset = load_dataset("mlabonne/FineTome-100k", split="train")
#dataset = load_dataset("mlabonne/FineTome-100k", split="train[:10000]")
dataset = load_dataset("mlabonne/FineTome-100k", split="train[:3000]")
#dataset = dataset.map(apply_template, batched=True)


# ###


trainer=SFTTrainer(
    model=model,
    tokenizer=tokenizer,
    train_dataset=dataset,
    dataset_text_field="text",
    max_seq_length=max_seq_length,
    dataset_num_proc=2,
    packing=True,
    args=TrainingArguments(
        learning_rate=3e-4,
        lr_scheduler_type="linear",
        per_device_train_batch_size=8,
        gradient_accumulation_steps=2,
        num_train_epochs=1,
        fp16=not is_bfloat16_supported(),
        bf16=is_bfloat16_supported(),
        logging_steps=1,
        optim="adamw_8bit",
        weight_decay=0.01,
        warmup_steps=10,
        output_dir="output",
        seed=0,
    ),
)

trainer.train()


# ###


model = FastLanguageModel.for_inference(model)

messages = [
    {"from": "human", "value": "Is 9.11 larger than 9.9?"},
]
inputs = tokenizer.apply_chat_template(
    messages,
    tokenize=True,
    add_generation_prompt=True,
    return_tensors="pt",
).to("cuda")

text_streamer = TextStreamer(tokenizer)
_ = model.generate(input_ids=inputs, streamer=text_streamer, max_new_tokens=128, use_cache=True)







```









# Reference

https://huggingface.co/blog/mlabonne/sft-llama3
https://huggingface.co/blog/mlabonne/merge-models
https://huggingface.co/bartowski/FineLlama-3.1-8B-GGUF?local-app=ollama








https://www.runpod.io/console/deploy

https://huggingface.co/mlabonne/Daredevil-8B

https://huggingface.co/nbeerbower/llama-3-gutenberg-8B





https://github.com/unslothai/unsloth
https://colab.research.google.com/github/unslothai/notebooks/blob/main/nb/Llama3.1_(8B)-Alpaca.ipynb




https://www.youtube.com/watch?v=Ucg1X_o1HDE




https://colab.research.google.com/drive/1Ys44kVvmeZtnICzWz0xgpRnrIOjZAuxp?usp=sharing


