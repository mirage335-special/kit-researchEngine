
Preferred version of Axolotl is from the official axolotl Docker image. Also should be reasonable to use the version of axolotl obtained through official installation steps, git repository, etc.

Obviously open to adapting the config to newer Axolotl versions, however, keeping changes minimal or configuring Axolotl to outright properly understand and use an older version configuration file could minimize extraneous changes that could cause the resulting model to output gibberish again.

Most concern is regarding the eos_token . More than just whether the '<|im_end|>' value is functionally equivalent to older configs used implicitly for the 'sharegpt' type, would very much appreciate information regarding what other values could have been implied for the 'sharegpt' type, etc. Would appreciate information about what values could be plausible from the original YAML specifications: dataset SE6446/MAGllama_Sharegpt , model arcee-ai/Llama-3.1-SuperNova-Lite , etc .
...








```bash
cd /workspace/axolotl
axolotl preprocess /workspace/data/example-se6446_llama-3.1-supernova-lite-reflection-v1_0.yml
```

```terminal
pydantic_core._pydantic_core.ValidationError: 1 validation error for AxolotlConfigWCapabilities
datasets
  Value error, `type: sharegpt.*` is deprecated. Please use `type: chat_template` instead. [type=value_error, input_value=[SFTDataset(path='SE6446/...e=False, revision=None)], input_type=list]
    For further information visit https://errors.pydantic.dev/2.10/v/value_error
```

A fresh dataset YAML specification has been suggested to correct this deprecation by available versions of axolotl .

```yaml
chat_template: chatml   # Use ChatML template for formatting multi-turn conversations (OpenAI Chat format)

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

special_tokens:
  eos_token: "<|im_end|>"   # Define the ChatML end-of-message token as the EOS token (ChatML uses <|im_end|> to terminate each turn):contentReference[oaicite:9]{index=9}
  additional_special_tokens: ["<thinking>", "</thinking>", "<reflection>", "</reflection>", "<output>", "</output>"]  # Ensure custom tags are recognized as single tokens
pad_token: "<|end_of_text|>"  # Use the end-of-text token as padding (to align with Llama tokenizer defaults):contentReference[oaicite:10]{index=10}
```

This however explicitly specifies the 'eos_token' as "<|im_end|>" . Does this really match the implied 'eos_token' value from the original YAML script with relevant previous versions of axolotl ? What are the possible implied values for the 'eos_token' per the original YAML script and various versions of axolotl ? What 'eos_token' values would seem plausible for the specifications of the original YAML script: dataset SE6446/MAGllama_Sharegpt , model arcee-ai/Llama-3.1-SuperNova-Lite , etc ?

Since this is an effort to get some 'hello world' examples of fine-tuning working, by duplicating the results of a published example, it may be best to not introduce unnecessary possible conflicts with a proven configuration that produced a model which did not output gibberish. Likewise, researching incongruencies with more recent versions of axolotl is also needed to anticipate and if possible prevent failed attempts: fine-tuning attempts can take hours at best.

Thus far, only an 'unsloth' fine tuning example has been successfully duplicated. An attempt to use OpenAI's fine-tuning services with a custom dataset has also resulted in a degraded fine-tuned model.

For now the emphasis is very much on correcting the discrepancy between the published example axolotl fine-tuning, and the requirements of available axolotl versions, to establish another basically working fine-tuning resource for fine tuning experiments towards training additional models.

https://huggingface.co/datasets/SE6446/MAGllama_Sharegpt
The Sharegpt dataset used in this experiment. Please consider information from pages through this link regarding the dataset format. The repository file data/train-00000-of-00001.parquet may be the original dataset , which may have been auto-converted again to the file train/0000.parquet under the convert/parquet/default branch - the dataset may or may not use either of these files when pulled from HuggingFace per the YAML specifications .

https://huggingface.co/SE6446/Llama-3.1-SuperNova-Lite-Reflection-V1.0
The published fine-tuning example used as the basis of this experiment. An axolotl config is provided. Inference from this model has been sensible, not gibberish.



Original axolotl config . 

```yaml
base_model: arcee-ai/Llama-3.1-SuperNova-Lite

load_in_8bit: false
load_in_4bit: false
strict: false

datasets:
  - path: SE6446/MAGllama_Sharegpt
    type: sharegpt
    conversation: chatml

dataset_prepared_path: /workspace/data/last_run_prepared
val_set_size: 0.05
output_dir: /workspace/data/outputs/out

sequence_len: 4096
sample_packing: true
pad_to_sequence_len: true
eval_sample_packing: false


hub_model_id: SE6446/Llama-3.1-SuperNova-Lite-Reflections-3
hub_strategy: every_save
use_auth_token: true

wandb_project: Bojangles
wandb_entity:
wandb_watch:
wandb_name: run-6
wandb_log_model: checkpoint

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
  pad_token: <|end_of_text|>
tokens:
  - <thinking>
  - </thinking>
  - <reflection>
  - </reflection>
  - <output>
  - </output>
```

```sharegpt
[ { "from": "system", "value": "You are a helpful AI assistant who, thinks and reflects on questions before answering fully." }, { "from": "human", "value": "I have $40,000 to invest and 2 investment opportunities. The first one requires a $5,000 investment for a guaranteed 10% return in 1 year. The second one requires a $20,000 investment for a 20% return in 1 year but carries some risk of losing 40% if things go bad. How can I best utilize my $40,000?\n\nTo provide your answer, follow these guidelines:\n\n1. Identify and state any assumptions you are making.\n2. List the decision alternatives available.\n3. Compute the outcome for each alternative.\n4. Decide on the best alternative." }, { "from": "gpt", "value": "<thinking>\nTo determine the best investment strategy, I need to weigh the potential returns against the risks and consider how to allocate the $40,000 effectively.\n\n</thinking>\n\n<reflection>\nWhat assumptions am I making?\n\n* The returns and risks associated with each investment opportunity are as stated and accurate.\n* The investments are mutually exclusive, meaning I can't invest in both with the same money at the same time.\n* There are no other investment opportunities or considerations such as taxes, fees, or the ability to diversify the investment.\n\n</reflection>\n\n<reflection>\nWhat are the decision alternatives?\n\n1. Invest $5,000 in the first opportunity and $35,000 in a risk-free or low-risk investment (e.g., savings account) with a presumed low return (e.g., 2%).\n2. Invest $20,000 in the second opportunity and $20,000 in the first opportunity.\n3. Invest $5,000 in the first opportunity and $35,000 in the second opportunity.\n4. Invest the entire $40,000 in the second opportunity.\n\n</reflection>\n\n<reflection>\nCompute the outcome for each alternative:\n\n1. $5,000 at 10% = $5,500; $35,000 at 2% = $35,700; Total = $41,200\n2. $20,000 at 10% = $22,000; $20,000 at 20% with no loss = $24,000; Total = $46,000\n3. $5,000 at 10% = $5,500; $35,000 at 20% with no loss = $42,000; Total = $47,500\n4. $40,000 at 20% with no loss = $48,000 (but risks losing 40% which would result in $24,000).\n\n</reflection>\n\n<reflection>\nDeciding the best alternative considering both return and risk:\n\n- Alternatives 1 and 2 are relatively safe but offer lower returns.\n- Alternatives 3 and 4 offer higher potential returns but come with risk, especially Alternative 4 which could result in a significant loss.\n\nGiven the potential for high return and the fact that Alternative 3 spreads risk between a guaranteed 10% return and a risky 20% return, it seems to balance risk and potential reward effectively.\n\n</reflection>\n\n\n\n<output>\nThe best way to utilize the $40,000, considering both potential return and risk, is to invest $5,000 in the first opportunity for a guaranteed 10% return and $35,000 in the second opportunity for a 20% return. This strategy spreads risk and potentially yields a high return while avoiding the all-or-nothing risk of investing the entire amount in the second opportunity. The potential total return would be $47,500, offering a balance between risk and reward.</output>" } ]
```















