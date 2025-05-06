
Essential information to operate 'Llama-tech' factory .
```
[___quick]'/project/zFactory/'Llama-tech
```

# Program Installation (if not already done)

```bash
# ###

if [[ -e /workspace/ubiquitous_bash/ubiquitous_bash.sh ]]
then
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
fi
#clear

# ###
```


```bash
# https://huggingface.co/blog/mlabonne/sft-llama3
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
apt-get install python3.10 python3.10-dev python3.10-distutils -y
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
update-alternatives --config python3

curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3
python -m pip install --upgrade pip --cache-dir "$PIP_CACHE_DIR"
python -m pip install --upgrade pip setuptools wheel --cache-dir "$PIP_CACHE_DIR"



python -m pip uninstall -y torch torchvision torchaudio triton unsloth unsloth_zoo xformers sympy mpmath

pip install "sympy>=1.13.3" "mpmath>=1.3"

pip install torch==2.3.0 torchvision==0.18.0+cu121 torchaudio==2.3.0+cu121 triton==2.3.0 --index-url https://download.pytorch.org/whl/cu121 --cache-dir "$PIP_CACHE_DIR"

python -m pip install --upgrade pip --cache-dir "$PIP_CACHE_DIR"


#pip install unsloth_zoo==2025.3.12
#pip install --no-deps unsloth_zoo==2025.3.12

#"unsloth @ git+https://github.com/unslothai/unsloth.git"
#pip install "unsloth[colab-new] @ git+https://github.com/unslothai/unsloth.git" --cache-dir "$PIP_CACHE_DIR"
PIP_PREFER_BINARY=1 pip install --prefer-binary --no-build-isolation "unsloth[cu121-torch230]"
#pip install "unsloth"


pip install --no-deps "xformers<0.0.27" "trl<0.9.0" peft accelerate bitsandbytes --cache-dir "$PIP_CACHE_DIR"
#pip install torch torchvision torchaudio --cache-dir "$PIP_CACHE_DIR"

```


# Fine Tuning (unsloth)


```bash
# https://huggingface.co/blog/mlabonne/sft-llama3
# https://huggingface.co/blog/mlabonne/merge-models
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

```

```python
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

```
```output
Unsloth 2025.4.3 patched 32 layers with 32 QKV layers, 32 O layers and 32 MLP layers.
```


```python
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
dataset = dataset.map(apply_template, batched=True)

```

```python
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

```









# Reference

https://www.runpod.io/console/deploy

https://huggingface.co/mlabonne/Daredevil-8B

https://huggingface.co/nbeerbower/llama-3-gutenberg-8B





https://github.com/unslothai/unsloth
https://colab.research.google.com/github/unslothai/notebooks/blob/main/nb/Llama3.1_(8B)-Alpaca.ipynb




https://www.youtube.com/watch?v=Ucg1X_o1HDE





https://huggingface.co/blog/mlabonne/sft-llama3
https://huggingface.co/blog/mlabonne/merge-models



https://colab.research.google.com/drive/1Ys44kVvmeZtnICzWz0xgpRnrIOjZAuxp?usp=sharing


