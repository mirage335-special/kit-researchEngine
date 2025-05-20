




DUBIOUS
```bash
export HF_HOME=/path/to/big_disk/hf_cache
apt-get install ffmpeg -y
pip3 install --upgrade git+https://github.com/huggingface/transformers.git
```


```bash
cd /workspace/data
python
```

```python
from nemo.collections import llm
llm.import_ckpt(model=llm.LlamaNemotronModel(llm.Llama31NemotronUltra253BConfig()), source='hf://nvidia/Llama-3_1-Nemotron-Ultra-253B-v1')
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



