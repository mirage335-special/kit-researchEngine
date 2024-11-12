
# NOTICE: Call this script during '_custom' or similarly otherwise within the 'chroot' commands of 'ubDistBuild' forks used to customize a derivative of 'ubdist' .
# This is to assist with building a developer 'operating system' disk image, bootable disc ISO, etc .

# https://github.com/soaringDistributions/ubDistBuild

# https://en.wikipedia.org/wiki/SearXNG
# https://github.com/searxng/searxng

# https://docs.openwebui.com/getting-started/quick-start
# https://openwebui.com/
# https://github.com/open-webui


# ATTENTION: Assumes and requires, must be present:
# ubiquitous_bash functions (tested for ubDistBuild forks)
# "$scriptAbsoluteLocation"
# "$HOME"/core/infrastructure/ubiquitous_bash
#  .../_lib/kit/app/researchEngine
# docker



_setup_researchEngine() {
	local functionEntryPWD
	functionEntryPWD="$PWD"
	
	
	
	_hook_ollama_nohistory
	
	
	_messageNormal '_setup_ollama'
	"$scriptAbsoluteLocation" _setup_ollama
	
	
	_messageNormal 'Test Docker'
	# DANGER: AVOID if possible, 'docker logout' may not zero from free space on disk image!
	# Token in theory can be limited to read-only public access (limiting abuse), in practice, exploits are VERY commonly used for defamation and worse.
	#export DOCKERHUB_USERNAME=x
	#export DOCKERHUB_TOKEN=x
	
	#_test_docker
	docker run hello-world
	
	
	# https://en.wikipedia.org/wiki/SearXNG
	# https://github.com/searxng/searxng
	_setup_searxng
	
	# https://docs.openwebui.com/getting-started/quick-start
	# https://openwebui.com/
	# https://github.com/open-webui
	_setup_openwebui
	
	
	_setup_models_extra
	
	
	
	docker logout
	
	
	
	cd "$functionEntryPWD"
	#_stop
}


_hook_ollama_nohistory() {
	_messageNormal 'Hook OLLAMA_NOHISTORY'
	# CAUTION: Assumes '_setupUbiquitous' has been called to hook '~/.bash_profile' to also call '~/.bashrc'.
	! grep OLLAMA_NOHISTORY "$HOME"/.bashrc > /dev/null 2>&1 && _messagePlain_probe "echo OLLAMA_NOHISTORY=true"' >> '"$HOME"/.bashrc && echo "OLLAMA_NOHISTORY=true" >> "$HOME"/.bashrc
	! grep OLLAMA_NOHISTORY "$HOME"/.bashrc > /dev/null 2>&1 && _messagePlain_bad 'missing: bashrc hook' && _messageFAIL && return 1
}


_setup_searxng() {
	local functionEntryPWD
	functionEntryPWD="$PWD"
	
	_messageNormal 'Install SearXNG (much more powerful search engine)'
	_messagePlain_nominal 'SearXNG: copy patch'

	mkdir -p "$HOME"/core/data/searxng

	cp "$HOME"/core/infrastructure/ubiquitous_bash/_lib/kit/app/researchEngine/_import/etc--searxng/settings.yml.patch "$HOME"/core/data/searxng/

	docker rm -f searxng

	_messagePlain_nominal 'SearXNG: docker'
	docker pull searxng/searxng:latest
	docker run -d --name searxng -p 127.0.0.1:8080:8080 -v "$HOME"/core/data/searxng:/etc/searxng --restart always searxng/searxng:latest
	sleep 120

	docker stop searxng



	_messagePlain_nominal 'SearXNG: patch'
	cd "$HOME"/core/data/searxng
	if [[ -e "$HOME"/core/data/searxng/settings.yml.patch ]] && sudo -n patch -p1 "$HOME"/core/data/searxng/settings.yml < "$HOME"/core/infrastructure/ubiquitous_bash/_lib/kit/app/researchEngine/_import/etc--searxng/settings.yml.patch && [[ ! -e "$HOME"/core/data/searxng/settings.yml.rej ]]
	then
		_messagePlain_good 'patch: success: patch exit status'
	elif [[ -e "$HOME"/core/data/searxng/settings.yml.rej ]]
	then
		_messagePlain_bad 'patch: fail: present: rej file'
		_messageFAIL
	else
		if ! [[ -e "$HOME"/core/data/searxng/settings.yml.patch ]]
		then
		_messagePlain_bad 'patch: fail: missing: patch file'
		_messageFAIL
		fi
		_messagePlain_bad 'patch: fail: patch exit status'
	fi
	cd "$functionEntryPWD"
	
	docker restart searxng
}


_setup_openwebui() {
	_messageNormal 'Install OpenWebUI'
	
	mkdir -p "$HOME"/core/data/openwebui
	
	_messagePlain_nominal 'OpenWebUI: docker'
	
	docker rm -f open-webui
	
	docker pull ghcr.io/open-webui/open-webui:main
	docker run -d -p 127.0.0.1:3000:8080 -e WEBUI_AUTH=False -e OLLAMA_NOHISTORY=true --add-host=host.docker.internal:host-gateway -v/c/core/data/openwebui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
	
	# OPTIONAL alternative. Discouraged unless either necessary (possibly to use built-in embedding AI model for RAG, instead of ollama) or unless internal NVIDIA GPU is permanently installed and absence of external GPU will NOT cause 'GPU container missing' failures (because NVIDIA likes to ensure their dirvers break if anyone ever uses anyone else's hardware).
	# WARNING: Especially strongly discouraged for automatic installation, as 'ollama' will already use GPU if available, and built-in NVIDIA GPU support for only unusual use cases is NOT a sane default!
	#  If these commands are used, it may be most sensible to include these in a script already installing NVIDIA drivers.
	#_bash> docker pull ghcr.io/open-webui/open-webui:cuda
	#_bash> docker run -d -p 127.0.0.1:3000:8080 -e WEBUI_AUTH=False -e OLLAMA_NOHISTORY=true --gpus all --add-host=host.docker.internal:host-gateway -v/c/core/data/openwebui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda
	
	_messagePlain_request 'SearXNG URL for OpenWebUI: http://host.docker.internal:8080/search?q=<query>'
	_messagePlain_request 'Search results 20, Concurrent 20 . Do NOT bypass SSL, enable SSL.'
	_messagePlain_request 'Import config file: "'$HOME'"/core/infrastructure/ubiquitous_bash/_lib/kit/app/researchEngine/_import/openwebui/config-1731195770155.json'
}

_setup_models_extra() {
	_messageNormal 'Install Models (non-Augment)'
	
	_messagePlain_probe_cmd ollama run llava-llama3 "Please output the word true . Any other output accompanying the word true is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word true will be very helpful whereas any output other than the word true will be unhelpful . Please output the word true ."
	
	_messagePlain_probe_cmd ollama run x/llama3.2-vision "Please output the word true . Any other output accompanying the word true is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word true will be very helpful whereas any output other than the word true will be unhelpful . Please output the word true ."
	
	_messagePlain_probe_cmd ollama run starcoder2:3b ""
	
	_messagePlain_probe_cmd ollama run nomic-embed-text ""
}


