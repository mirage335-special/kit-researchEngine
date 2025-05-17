Essential information to operate 'Llama-tech' factory .
```
[___quick]'/project/zFactory/'Llama-tech
```


# Compatibility - Docker, RunPod

CMD  bash -c 'mkdir -p ~/.ssh ; chmod 700 ~/.ssh ; echo "$PUBLIC_KEY" > ~/.ssh/authorized_keys ; chmod 600 ~/.ssh/authorized_keys ; service ssh start ; sleep infinity'  directive may be necessary for some cloud providers (eg. RunPod) . Conversely, 'null' or '/bin/bash' may be appropriate CMD directives otherwise.

Do NOT mount a volume directly to the container '/workspace' directory - this will interfere with '/workspace/axolotl'.



# Scrap - Fine Tuning

Commands using 'accelerate' instead of 'axolotl' expected deprecated.



# Scrap - Inference

```bash
# When training finishes, you can test inference with this:
accelerate launch scripts/finetune.py examples/openllama-7b/qlora.yml --inference --lora_model_dir="./qlora-out"


# DUBIOUS
axolotl inference /workspace/project/experiment-ubiquitous_bash-lora.yml
```



# Scrap - Quantization

axolotl merge-lora /workspace/project/experiment-ubiquitous_bash-lora.yml --lora-model-dir="/outputs/experiment-ubiquitous_bash/lora-out" --output-dir="/outputs/experiment-ubiquitous_bash"
axolotl merge-lora /workspace/project/experiment-lora-1b.yml --lora-model-dir="/outputs/lora-out/experiment-lora-1b/lora-out" --output-dir=/outputs/experiment-lora-1b

python /workspace/project/_lib/llama.cpp/convert_hf_to_gguf.py /outputs/experiment-ubiquitous_bash/merged --outfile /outputs/experiment-ubiquitous_bash-lora-f32.gguf --outtype f32
python /workspace/project/_lib/llama.cpp/convert_hf_to_gguf.py /outputs/experiment-lora-1b/merged --outfile /outputs/experiment-lora-1b-f32.gguf --outtype f32


# Scrap - Inference (Ollama)

#cat <<'EOF' > experiment-ubiquitous_bash.Modelfile
cat <<'EOF' > experiment-lora-1b.Modelfile
#FROM ./outputs/experiment-ubiquitous_bash-lora-f32.gguf
FROM ./outputs/experiment-lora-1b-f32.gguf


#FROM ./models/Llama-3.2-1B
#ADAPTER ./outputs/experiment-ubiquitous_bash/lora-out

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

LICENSE "LLAMA 3.2 COMMUNITY LICENSE AGREEMENT"

EOF

#ollama create llama3-ubiquitous-bash-1b -f experiment-ubiquitous_bash.Modelfile
ollama create experiment-lora-1b -f experiment-lora-1b.Modelfile







# Scrap - Example





# Scratch - Example

https://huggingface.co/SE6446/Llama-3.1-SuperNova-Lite-Reflection-V1.0
https://huggingface.co/mradermacher/Llama-3.1-SuperNova-Lite-Reflection-V1.0-i1-GGUF
_service_ollama_augment
ollama run hf.co/mradermacher/Llama-3.1-SuperNova-Lite-Reflection-V1.0-i1-GGUF:IQ3_XXS 'Please tell me a short story.'


cd /workspace/axolotl
axolotl preprocess /workspace/data/example-se6446_llama-3.1-supernova-lite-reflection-v1_0.yml





# Scrap - Example

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













# Reference

https://blog.runpod.io/how-to-achieve-true-ssh-on-runpod/




