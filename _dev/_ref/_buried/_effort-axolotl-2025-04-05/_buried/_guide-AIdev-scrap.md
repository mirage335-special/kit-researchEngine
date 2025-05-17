
Possibly relevant, possibly DUBIOUS, commands:
```bash
# DUBIOUS
#CUDA_VISIBLE_DEVICES="" python -m axolotl.cli.preprocess examples/openllama-3b/lora.yml
#accelerate launch --num_processes=2 -m /workspace/project/Llama-augment-ubiquitous_bash-lora.yml --deepspeed deepspeed_configs/zero1.json
#axolotl train /workspace/project/Llama-augment-ubiquitous_bash-lora.yml



# DUBIOUS - from https://docs.runpod.io/tutorials/pods/fine-tune-llm-axolotl
#pip3 install packaging ninja
#pip3 install -e '.[flash-attn,deepspeed]'

#CUDA_VISIBLE_DEVICES=""
#python -m axolotl.cli.preprocess examples/openllama-3b/lora.yml

#accelerate launch -m axolotl.cli.train examples/openllama-3b/lora.yml

## Very DUBIOUS . Seems this does not accept simple text prompting, requiring at least prompt formatting, and maybe only responding correctly to specialized JSON beyond that.
## https://www.llama.com/docs/model-cards-and-prompt-formats/llama3_1/
#accelerate launch -m axolotl.cli.inference examples/openllama-3b/lora.yml --lora_model_dir="./lora-out"

#python3 -m axolotl.cli.merge_lora examples/openllama-3b/lora.yml --lora_model_dir="./lora-out"


# DUBIOUS - from https://axolotl-ai-cloud.github.io/axolotl/docs/inference.html
## Very DUBIOUS . Seems this does not accept simple text prompting, requiring at least prompt formatting, and maybe only responding correctly to specialized JSON beyond that.
axolotl inference your_config.yml --lora-model-dir="./lora-output-dir"
axolotl inference your_config.yml --base-model="./completed-model"
axolotl inference your_config.yml --gradio
cat /tmp/prompt.txt | axolotl inference your_config.yml --base-model="./completed-model" --prompter=None
axolotl inference your_config.yml --load-in-8bit=True


# DUBIOUS - from https://axolotl-ai-cloud.github.io/axolotl/docs/inference.html
## Configuration Options (alternative)
#  #gpu_memory_limit: 20GiB  # Adjust based on your GPU
#  #lora_on_cpu: true        # Process on CPU if needed
#CUDA_VISIBLE_DEVICES="" axolotl merge-lora ...

# from https://axolotl-ai-cloud.github.io/axolotl/docs/inference.html
#axolotl preprocess your_config.yml --debug
```





















Quantize, Inference, commands from https://medium.com/@qdrddr/the-easiest-way-to-convert-a-model-to-gguf-and-quantize-91016e97c987 .
```bash
# Docker

mkdir -p ~/models
huggingface-cli login
huggingface-cli download mistralai/Mistral-7B-Instruct-v0.3 --local-dir "~/models" --include "*"

#Convert to GGUF
docker run --rm -v "~/models":/repo ghcr.io/ggerganov/llama.cpp:full --convert "/repo" --outtype f32
ls ~/models | grep .gguf
#> ggml-model-f32.gguf

#Quantize from F32.gguf to Q4_K_M.bin
docker run --rm -v "~/models":/repo ghcr.io/ggerganov/llama.cpp:full --quantize "/repo/ggml-model-f32.gguf" "/repo/ggml-model-Q4_K_M.bin" "Q4_K_M"
ls ~/models | grep .bin
#> ggml-model-Q4_K_M.bin


# ollama (alternative)

#GGUF to q6_K
echo "FROM hf.co/bartowski/Llama-3.2-3B-Instruct-GGUF:F16" > "~/models/modelfile"
ollama create hf.co/bartowski/Llama-3.2-1B-Instruct-GGUF:q6_K --quantize q6_K --file ~/models/modelfile


#Safetensors
model=sentence-transformers-testing/stsb-bert-tiny-safetensors
modelname=hf.co/${model}
modeldir=${PWD}/${model}
mkdir -p "${modeldir}" && huggingface-cli download "${model}" --local-dir "${modeldir}" --include "*"
echo "FROM ${modeldir}" > "${modeldir}/modelfile"
ollama create $modelname -f ${modeldir}/modelfile
ollama list | grep $modelname


# ollama without temporary GGUF

model=mistralai/Mistral-7B-Instruct-v0.3
modelname=Mistral:7b-Instruct-v0.3
modelfolder=${PWD}/${model}

huggingface-cli login
huggingface-cli download "${model}" --local-dir "${modelfolder}" --include "*"

#Pointing to directory with PyTorch/Safetensors might not always work, try creating GGUF 
echo "FROM ${modeldir}" > "${modeldir}/modelfile"
ollama create "${modelname}" -f "${modeldir}/modelfile"

#If pointing to folder doesn't work, then with GGUF it should work:
echo "FROM ${modeldir}/ggml-model-f16.gguf" > "${modeldir}/modelfile"
ollama create "${modelname}" -f "${modeldir}/modelfile"
```


Quantize, Inference, commands from https://medium.com/@kevin.lopez.91/simple-tutorial-to-quantize-models-using-llama-cpp-from-safetesnsors-to-gguf-c42acf2c537d .

```bash
sudo apt-get install git git-lfs
git lfs install
git-lfs clone https://huggingface.co/microsoft/phi-2

conda create — name phi_llm
conda activate phi_llm

git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp/
pip install -r requirements.txt
make -j8 
# if you have cuda enabled Try using the below instead
# make LLAMA_CUBLAS=1 -j8

# use the convert script to convert the models from hf to gguf
./convert-hf-to-gguf.py ../phi-2/ — outfile phi-2_fp16.gguf
cd ../

# convert the model from fp16 to q4
./llama.cpp/quantize phi-2_fp16.gguf phi-2_Q4_K_M.gguf Q4_K_M

# test
llama.cpp/main — model phi-2_Q4_K_M.gguf — interactive
# if you want to use a GPU then try: 
# llama.cpp/main — model phi-2_Q4_K_M.gguf — interactive -ngl <number of layers your gpu can handle (3090 can do all layers)>


# alternative

pip install llama-cpp-python
# If you want to use cuda try this:
# CMAKE_ARGS=”-DLLAMA_CUBLAS=on” pip install llama-cpp-python

python3
```
```python
import os
import argparse
import llama_cpp
from llama_cpp import llama_model_quantize_params

result = llama_cpp.llama_model_quantize("phi-2_fp16.gguf".encode("utf-8"), "phi-2_Q4_1_low_level.gguf".encode("utf-8"), llama_model_quantize_params(0,3,True, True, False))
```
```bash
# test
llama.cpp/main — model phi-2_Q4_K_M.gguf — interactive
# if you want to use a GPU then try: 
# llama.cpp/main — model phi-2_Q4_K_M.gguf — interactive -ngl <number of layers your gpu can handle (3090 can do all layers)>
```


Quantize, Inference, GGML commands from https://towardsdatascience.com/quantize-llama-models-with-ggml-and-llama-cpp-3612dfbcc172/ .
```bash
# Install llama.cpp
!git clone https://github.com/ggerganov/llama.cpp
!cd llama.cpp && git pull && make clean && LLAMA_CUBLAS=1 make
!pip install -r llama.cpp/requirements.txt

MODEL_ID = "mlabonne/EvolCodeLlama-7b"

# Download model
!git lfs install
!git clone https://huggingface.co/{MODEL_ID}

MODEL_NAME = MODEL_ID.split('/')[-1]

# Convert to fp16
fp16 = f"{MODEL_NAME}/{MODEL_NAME.lower()}.fp16.bin"
!python llama.cpp/convert.py {MODEL_NAME} --outtype f16 --outfile {fp16}

QUANTIZATION_METHODS = ["q4_k_m", "q5_k_m"]

for method in QUANTIZATION_METHODS:
    qtype = f"{MODEL_NAME}/{MODEL_NAME.lower()}.{method.upper()}.gguf"
    !./llama.cpp/quantize {fp16} {qtype} {method}

# Our two quantized models are now ready for inference.
```
```python
import os

model_list = [file for file in os.listdir(MODEL_NAME) if "gguf" in file]

prompt = input("Enter your prompt: ")
chosen_method = input("Name of the model (options: " + ", ".join(model_list) + "): ")

# Verify the chosen method is in the list
if chosen_method not in model_list:
    print("Invalid name")
else:
    qtype = f"{MODEL_NAME}/{MODEL_NAME.lower()}.{method.upper()}.gguf"
    !./llama.cpp/main -m {qtype} -n 128 --color -ngl 35 -p "{prompt}"
```


Fine Tune, Quantize, Inference, commands from https://www.animal-machine.com/posts/fine-tuning-llama-models-with-qlora-and-axolotl/ .
```
# Setup a new conda environment pinned to python 3.9
conda create -n axolotl python=3.9
conda activate axolotl

# Install pytorch for cuda 11.8
pip3 install torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu118

# Clone the github and switch directories to it
git clone https://github.com/OpenAccess-AI-Collective/axolotl
cd axolotl

# As of the time of this writing, 0.2.1 is the latest release
git checkout tags/v0.2.1

# Install the dependencies
pip3 install -e .
pip3 install -U git+https://github.com/huggingface/peft.git

# I have problems with the current bitandbytes unless I force
# the the cuda 11.8 version onto the cpu version ...
cd ~/miniconda3/envs/axolotl/lib/python3.9/site-packages/bitsandbytes
mv libbitsandbytes_cpu.so backup_libbitsandbytes_cpu.so
cp libbitsandbytes_cuda118.so libbitsandbytes_cpu.so

cd ~/axolotl
accelerate config  # selected no distributed training and defaults

# Copy the 3B qlora example for open-llama into a new directory
mkdir examples/openllama-7b
cp examples/openllama-3b/qlora.yml \
    examples/openllama-7b/qlora.yml

vim examples/openllama-7b/qlora.yml
## EDIT this qlora.yml to change these keys to target the 7B model
#    base_model: openlm-research/open_llama_7b
#    base_model_config: openlm-research/open_llama_7b

# This will take some time. Output will be in `./qlora-out`
accelerate launch scripts/finetune.py \
    examples/openllama-7b/qlora.yml

# When training finishes, you can test inference with this:
accelerate launch scripts/finetune.py \
    examples/openllama-7b/qlora.yml \
    --inference --lora_model_dir="./qlora-out"

# Merge the lora weights into one file
accelerate launch scripts/finetune.py \
    examples/openllama-7b/qlora.yml \
    --merge_lora --lora_model_dir="./qlora-out" \
    --load_in_8bit=False --load_in_4bit=False

# Now we have a merged model in ./qlora-out/merged
# We need to copy the tokenizer.model back into this directory
cd qlora-out/merged
wget https://huggingface.co/openlm-research/open_llama_7b/resolve/main/tokenizer.model

# Setup llama.cpp for quantization and inference 
# (steps shown for linux; ymmv)
cd $HOME
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp
make LLAMA_CUBLAS=1

# We need to convert the pytorch model into ggml for quantization
# It crates 'ggml-model-f16.bin' in the 'merged' directory.
python convert.py --outtype f16 \
    ~/axolotl/qlora-out/merged/pytorch_model-00001-of-00002.bin 

# Start off by making a basic q4_0 4-bit quantization.
# It's important to have 'ggml' in the name of the quant for some 
# software to recognize it's file format. 
./quantize ~/axolotl/qlora-out/merged/ggml-model-f16.bin \
    ~/axolotl/qlora-out/merged/openllama-7b-GPT4-ggml-q4_0.bin q4_0

# There we go! Now we have a quantized fine-tuned model! 
# You can test it out with llama.cpp
./main -n 128 --color -i -r "User:" -f prompts/chat-with-bob.txt \
    -m ~/axolotl/qlora-out/merged/openllama-7b-GPT4-ggml-q4_0.bin
```


Inference, Quantize commands and Modelfile parameters from https://github.com/ollama/ollama/blob/main/docs/import.md .

Importing a fine tuned adapter from Safetensors weights
```Modelfile
FROM <base model name>
ADAPTER /path/to/safetensors/adapter/directory
```
```bash
ollama create my-model
ollama create my-model
```

Importing a model from Safetensors weights
```Modelfile
FROM /path/to/safetensors/directory
```
```bash
ollama create my-model
```
```bash
ollama run my-model
```

Importing a GGUF based model or adapter
```Modelfile
#To import a GGUF model, create a Modelfile containing:
FROM /path/to/file.gguf
```
```Modelfile
#(alternative)
#For a GGUF adapter, create the Modelfile with:
FROM <model name>
ADAPTER /path/to/file.gguf
```
```bash
ollama create my-model
```

Quantizing a Model
```Modelfile
FROM /path/to/my/gemma/f16/model
```
```bash
ollama create --quantize q4_K_M mymodel
```



















