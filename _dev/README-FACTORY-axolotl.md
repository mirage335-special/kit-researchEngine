Essential information to operate 'Llama-tech' factory .
```
[___quick]'/project/zFactory/'Llama-tech
```



# Certification

Apparently able to create sane output NOT gibberish fine tuned AI models:


## 2025-05-14

Factory Docker containers built somewhat recently as of 2025-05-18 .
https://github.com/orgs/mirage335-colossus/packages?repo_name=ubiquitous_bash



# Compatibility - Docker, RunPod

CMD  bash -c 'mkdir -p ~/.ssh ; chmod 700 ~/.ssh ; echo "$PUBLIC_KEY" > ~/.ssh/authorized_keys ; chmod 600 ~/.ssh/authorized_keys ; service ssh start ; sleep infinity'  directive may be necessary for some cloud providers (eg. RunPod) . Conversely, 'null' or '/bin/bash' may be appropriate CMD directives otherwise.

Do NOT mount a volume directly to the container '/workspace' directory - this will interfere with '/workspace/axolotl'.



# Scrap - Example

https://huggingface.co/SE6446/Llama-3.1-SuperNova-Lite-Reflection-V1.0
https://huggingface.co/mradermacher/Llama-3.1-SuperNova-Lite-Reflection-V1.0-i1-GGUF
 'License: llama3.1' (inherits Llama 3.1 license as usual)
```bash
_service_ollama_augment
ollama run hf.co/mradermacher/Llama-3.1-SuperNova-Lite-Reflection-V1.0-i1-GGUF:IQ3_XXS 'Please tell me a short story.'
```


example-se6446_llama-3.1-supernova-lite-reflection-v1_0.yml
```yml
base_model: arcee-ai/Llama-3.1-SuperNova-Lite

load_in_8bit: false
load_in_4bit: false
strict: false

# DUBIOUS: Apparently deprecated.
#datasets:
  #- path: SE6446/MAGllama_Sharegpt
    #type: sharegpt
    #conversation: chatml


chat_template: chatml   # Use ChatML template for formatting multi-turn conversations (OpenAI Chat format)

#chat_template: tokenizer_default
#chat_template: tokenizer_default_fallback_chatml
#chat_template: chatml
# alpaca/inst/chatml/gemma/cohere/llama3/phi_3/deepseek_v2/jamba


datasets:
  - path: SE6446/MAGllama_Sharegpt
    type: chat_template        # New dataset type (replaces deprecated 'sharegpt')
    field_messages: conversations       # Key in each data sample that holds the list of message dicts:contentReference[oaicite:1]{index=1}
    message_property_mappings:         # Map the dataset's message fields to the template's expected fields:contentReference[oaicite:2]{index=2}
      role: from           # The dataset uses "from" (e.g. 'human', 'gpt', 'system') to indicate speaker role
      content: value       # The dataset uses "value" to hold the message content text
    roles:                              # Map dataset-specific role labels to the standard roles used in the template:contentReference[oaicite:3]{index=3}
      assistant:
        - gpt              # Treat any "from: gpt" as an assistant role (the AI's responses):contentReference[oaicite:4]{index=4}
      user:
        - human            # Treat any "from: human" as a user role (the human prompts):contentReference[oaicite:5]{index=5}
      # (No mapping needed for "system" – it's already named "system", which the ChatML template will recognize as a system role)
    roles_to_train: ["assistant"]       # Only train on the assistant's responses; user/system prompts are masked out:contentReference[oaicite:6]{index=6}:contentReference[oaicite:7]{index=7}
    train_on_eos: "turn"               # Only train on end-of-turn tokens for assistant messages (skip EOS tokens after user/system turns):contentReference[oaicite:8]{index=8}


dataset_prepared_path: /workspace/data/last_run_prepared
val_set_size: 0.05
output_dir: /workspace/data/outputs/out

sequence_len: 4096
sample_packing: true
pad_to_sequence_len: true
eval_sample_packing: false


# DUBIOUS . This is an experiment, so probably just inconvenient to save the model elsewhere.
#hub_model_id: SE6446/Llama-3.1-SuperNova-Lite-Reflections-3
#hub_strategy: every_save
#use_auth_token: true

#wandb_project: Bojangles
#wandb_entity:
#wandb_watch:
#wandb_name: run-6
#wandb_log_model: checkpoint


gradient_accumulation_steps: 2
micro_batch_size: 1
num_epochs: 2
optimizer: paged_adamw_8bit
lr_scheduler: cosine
learning_rate: 0.00015

adapter: lora
lora_model_dir:
lora_r: 32
lora_alpha: 16
lora_dropout: 0.05
lora_target_linear: true
lora_fan_in_fan_out:
lora_modules_to_save:
  - embed_tokens
  - lm_head

train_on_inputs: false
group_by_length: false
bf16: auto
fp16:
tf32: false

gradient_checkpointing: true
gradient_checkpointing_kwargs:
  use_reentrant: false
early_stopping_patience:
resume_from_checkpoint:
logging_steps: 1
xformers_attention:
flash_attention: false

warmup_steps: 10
evals_per_epoch: 2
eval_table_size:
saves_per_epoch: 1
debug:
deepspeed:
weight_decay: 0.0
fsdp:
fsdp_config:
special_tokens:
  eos_token: "<|im_end|>"
  # DUBIOUS . Apparently 'eos_token' should specify the string to translate to the tokenizer's EOS, specifying the dataset template ChatML EOS string to translate, instead of the already existing model native end-of-text token.
  #eos_token: "<|eot_id|>"
  #eos_token: "<|end_of_text|>"
  # DUBIOUS . Examples show this as a top-level 'tokens' value rather than under 'special_tokens'. ChatGPT suggestion to define this way is expected a mistake.
  #additional_special_tokens: ["<thinking>", "</thinking>", "<reflection>", "</reflection>", "<output>", "</output>"]
  pad_token: <|end_of_text|>
tokens:
  - <thinking>
  - </thinking>
  - <reflection>
  - </reflection>
  - <output>
  - </output>

# DUBIOUS . Examples show this under 'special_tokens' rather than a top-level value. ChatGPT suggestion to define this way is expected a mistake.
#pad_token: <|end_of_text|>


```



```bash
cd /workspace/axolotl

axolotl preprocess /workspace/data/example-se6446_llama-3.1-supernova-lite-reflection-v1_0.yml

axolotl train /workspace/data/example-se6446_llama-3.1-supernova-lite-reflection-v1_0.yml

env CUDA_VISIBLE_DEVICES=0 axolotl inference /workspace/data/example-se6446_llama-3.1-supernova-lite-reflection-v1_0.yml
```

```bash
cd /workspace/axolotl

axolotl merge-lora /workspace/data/example-se6446_llama-3.1-supernova-lite-reflection-v1_0.yml --lora-model-dir="/workspace/data/outputs/out"

python /opt/llama.cpp/convert_hf_to_gguf.py --outfile /workspace/data/outputs/out/model.gguf --outtype f16 /workspace/data/outputs/out/merged
```

ATTENTION: WARNING: NOTICE: Adding chat template, etc, information, to GGUF, Modelfile, etc, may necessitate additional steps.


```bash
_service_ollama_augment

cat <<'EOF' > example-se6446_llama-3.1-supernova-lite-reflection-v1_0.Modelfile
FROM /workspace/data/outputs/out/model.gguf

# DUBIOUS .
##FROM hf.co/arcee-ai/Llama-3.1-SuperNova-Lite
#FROM hf.co/bartowski/Llama-3.1-SuperNova-Lite-GGUF:Q4_K_M
#ADAPTER /workspace/data/outputs/out

TEMPLATE """<|start_header_id|>system<|end_header_id|>

Cutting Knowledge Date: December 2023

{{ if .System }}{{ .System }}
{{- end }}
{{- if .Tools }}When you receive a tool call response, use the output to format an answer to the orginal user question.

You are a helpful assistant with tool calling capabilities.
{{- end }}<|eot_id|>
{{- range $i, $_ := .Messages }}
{{- $last := eq (len (slice $.Messages $i)) 1 }}
{{- if eq .Role "user" }}<|start_header_id|>user<|end_header_id|>
{{- if and $.Tools $last }}

Given the following functions, please respond with a JSON for a function call with its proper arguments that best answers the given prompt.

Respond in the format {"name": function name, "parameters": dictionary of argument name and its value}. Do not use variables.

{{ range $.Tools }}
{{- . }}
{{ end }}
{{ .Content }}<|eot_id|>
{{- else }}

{{ .Content }}<|eot_id|>
{{- end }}{{ if $last }}<|start_header_id|>assistant<|end_header_id|>

{{ end }}
{{- else if eq .Role "assistant" }}<|start_header_id|>assistant<|end_header_id|>
{{- if .ToolCalls }}
{{ range .ToolCalls }}
{"name": "{{ .Function.Name }}", "parameters": {{ .Function.Arguments }}}{{ end }}
{{- else }}

{{ .Content }}
{{- end }}{{ if not $last }}<|eot_id|>{{ end }}
{{- else if eq .Role "tool" }}<|start_header_id|>ipython<|end_header_id|>

{{ .Content }}<|eot_id|>{{ if $last }}<|start_header_id|>assistant<|end_header_id|>

{{ end }}
{{- end }}
{{- end }}"""

LICENSE "LLAMA 3.1 COMMUNITY LICENSE AGREEMENT"

EOF

ollama create example-se6446_llama-3.1-supernova-lite-reflection-v1_0 -f example-se6446_llama-3.1-supernova-lite-reflection-v1_0.Modelfile

ollama run example-se6446_llama-3.1-supernova-lite-reflection-v1_0 'Please tell me a story.'

```






# Reference

https://blog.runpod.io/how-to-achieve-true-ssh-on-runpod/

https://axolotl-ui.vercel.app/




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

