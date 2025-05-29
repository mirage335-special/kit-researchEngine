




DUBIOUS
```bash
export HF_HOME=/path/to/big_disk/hf_cache
apt-get install ffmpeg -y
#pip3 install --upgrade git+https://github.com/huggingface/transformers.git

```


```bash
cd /workspace/data
#python
./example_trainNemotron.py

```

```python
from nemo.collections import llm
llm.import_ckpt(model=llm.LlamaNemotronModel(llm.Llama31NemotronUltra253BConfig()), source='hf://nvidia/Llama-3_1-Nemotron-Ultra-253B-v1')






from nemo.collections import llm

recipe = llm.llama33_nemotron_super_49b.finetune_recipe(
    name="llama33_nemotron_super_49b_finetuning",
    dir=f"/path/to/checkpoints",
    num_nodes=4,
    num_gpus_per_node=8,
    peft_scheme='lora',  # 'lora', 'none'
    packed_sequence=False,
)

# # To override the data argument
# dataloader = a_function_that_configures_your_custom_dataset(
#     gbs=gbs,
#     mbs=mbs,
#     seq_length=recipe.model.config.seq_length,
# )
# recipe.data = dataloader







import nemo_run as run

#run.run(pretrain, executor=run.LocalExecutor())
run.run(pretrain, direct=True)

```












# Reference

https://docs.nvidia.com/nemo-framework/user-guide/latest/llms/llama_nemotron.html
'Llama 3.1 Nemotron Nano 8B' 'Yes'
'Llama 3.3 Nemotron Super 49B' 'Yes'
'Llama 3.1 Nemotron Ultra 253B' 'Yes'

https://github.com/dominodatalab/nvidia-nemotron-finetuning
'nvcr.io/nvidia/nemo:24.01.framework'




https://catalog.ngc.nvidia.com/orgs/nvidia/containers/nemo
https://catalog.ngc.nvidia.com/orgs/nvidia/containers/nemo/tags



