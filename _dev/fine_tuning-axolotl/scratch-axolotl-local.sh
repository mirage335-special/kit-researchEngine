

! type _getAbsoluteLocation > /dev/null 2>&1 && exit 1

factory_projectDir=$(_getAbsoluteLocation .)
if [[ "$factory_projectDir" != '/cygdrive/c/q/p/zFactory/Llama-tech' ]] && [[ "$factory_projectDir" != "$HOME"/project/zFactory/Llama-tech ]]
then
_messagePlain_warn 'unexpected: factory_projectDir: '"$factory_projectDir"
_messagePlain_request 'request: Ctrl+C , close terminal, etc, NOW, if this is not what you intended !'
sleep 45
echo 'DANGER: proceeding! '
fi
[[ "$factory_projectDir" == '/cygdrive/c/q/p/zFactory/Llama-tech' ]] && factory_projectDir='/c/q/p/zFactory/Llama-tech'
[[ "$factory_projectDir" == '/cygdrive'* ]] && factory_projectDir=$(cygpath -w "$factory_projectDir")


factory_modelDir="$factory_projectDir"/models
factory_outputsDir="$factory_projectDir"/outputs

factory_datasetsDir='/c/q/p/zCore/infrastructure/ubiquitous_bash/_local/dataset'
#factory_datasetsDir="$factory_projectDir"/datasets


#--privileged
#--ipc=host --ulimit memlock=-1 --ulimit stack=67108864
#-v 'C:\q':/q -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads
docker run --shm-size=20g --name axolotl-$(_uid 14) --gpus "all" -v 'C:\q':/q -v 'C:\core':/core -v "$USERPROFILE"'\Downloads':/Downloads -v "$factory_outputsDir":/outputs -v "$factory_modelDir":/model -v "$factory_datasetsDir":/datasets -v "$factory_projectDir":/workspace/project --rm -it axolotlai/axolotl:main-latest


# ### ...

#pip3 install packaging ninja
#pip3 install -e '.[flash-attn,deepspeed]'

# ###

export NCCL_DEBUG=INFO
export NCCL_DEBUG_SUBSYS=ALL
export TORCH_DISTRIBUTED_DEBUG=INFO
export TORCHELASTIC_ERROR_FILE=/PATH/TO/torcherror.log

if [[ -e /core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh ]]
then
/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous_nonet
export profileScriptLocation="/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"
export profileScriptFolder="/core/infrastructure/ubiquitous_bash"
. "/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh" --profile _importShortcuts
else
! [[ -e /ubiquitous_bash.sh ]] && wget 'https://raw.githubusercontent.com/mirage335/ubiquitous_bash/master/ubiquitous_bash.sh'
mv -f ./ubiquitous_bash.sh /ubiquitous_bash.sh
chmod u+x /ubiquitous_bash.sh
/ubiquitous_bash.sh _setupUbiquitous_nonet
fi
clear

find /model -maxdepth 1 | head -n 65
find /outputs -maxdepth 1 | head
find /datasets -maxdepth 1 | head -n 65
find /workspace/project -maxdepth 1 | head -n 65

nvidia-smi


# ###


axolotl preprocess /workspace/project/experiment-ubiquitous_bash-lora.yml

#--deepspeed deepspeed_configs/zero1.json
axolotl train /workspace/project/experiment-ubiquitous_bash-lora.yml

axolotl inference /workspace/project/experiment-ubiquitous_bash-lora.yml




