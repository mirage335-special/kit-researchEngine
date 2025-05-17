
Seems available versions of axolotl now require a different specification of the dataset format. Please find a documented example using the newer dataset specification syntax for the sharegpt dataset format, and suggest an exactly compatible alternative datasets YAML stanza following that newer syntax for specifying the sharegpt formatted SE6446/MAGllama_Sharegpt dataset . Since this is an attempt to approximately but successfully duplicate the non-gibberish model resulting from a publicly documented fine-tuning example, it is important that any alternative specification not omit relevant features from the present YAML specification, to avoid unintentionally fine-tuning the model on repetitive or inaccurately formatted text, to prevent the resulting model from outputting gibberish after the fine-tuning training.


...

Any chat template format which preserves the necessary compatibility with the model, dataset, and fine-tuning, should be acceptable. The terminal output does explicitly suggest 'type: chat_template', so that may or may not be part of correct dataset syntax.

Preferably a drop-in replacement YAML stanza may minimize the chance of other implied or explicit changes to the YAML script introducing compatibility issues. This YAML script has used the existing 'special_tokens', 'pad_token', 'tokens', and any similar specifications implied by the 'type: sharegpt', 'conversation: chatml' dataset specification to create a non-gibberish model, thus in any case it may be best to not conflict with these configuration items.

The HuggingFace dataset path may still be referenced. Unnecessarily changing that or other things which may be easily changed later, seems a counterproductive risk to getting a working example, especially given that many previous attempts with axolotl fine-tuning have failed already due to very subtle changes to axolotl YAML format specification, dataset formatting, model input text formatting, and axolotl dependencies .

This is an effort to get some 'hello world' examples of fine-tuning working. Thus far, only an 'unsloth' fine tuning example has been successfully duplicated. An attempt to use OpenAI's fine-tuning services with a custom dataset has also resulted in a degraded fine-tuned model.

For now the emphasis is very much on correcting the discrepancy between the published example axolotl fine-tuning, and the requirements of available axolotl versions, to establish another basically working fine-tuning resource for fine tuning experiments towards training additional models.




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















