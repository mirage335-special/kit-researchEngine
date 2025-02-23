
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

_service_researchEngine-docker-chroot-start() {
	# ATTRIBUTION-AI ChatGPT o1 2024-12-24 .
	# WARNING: The 'DOCKER_RAMDISK=true' environment variable is necessary, and reportedly (ChatGPT) may be officially unofficial and controversial. An alternative may be to write a wrapper script temporarily replacing runc with the added parameter 'runc --no-pivot' ONLY if the 'run' command is detected (ie. convert 'runc run <container-id>' to 'runc --no-pivot run <container-id>' ) .
	_messageNormal 'Docker Service - Start'
	# WARNING: This does assume if dockerd is not already available, it is due to absence of ChRoot, with all mounting/unmounting being necessary. A reasonable assumption, but could cause issues (eg. breaking 'cgroup' on a running system).
	#local currentDockerPID
	currentDockerPID=""
	if ! docker ps && ! _if_cygwin
	then
		sudo -n mkdir -p /sys/fs/cgroup
		sudo -n mount -t cgroup2 none /sys/fs/cgroup || sudo -n mount -t cgroup none /sys/fs/cgroup
		sudo -n mkdir -p /var/run
		#sudo -n env DOCKER_RAMDISK=true dockerd --config-file=/dev/null --storage-driver=vfs --host=unix:///var/run/docker.sock --data-root=/var/lib/docker --exec-root=/var/run/docker >/var/log/dockerd.log 2>&1 &
		sudo -n env DOCKER_RAMDISK=true dockerd --host=unix:///var/run/docker.sock --data-root=/var/lib/docker --exec-root=/var/run/docker 2>&1 | sudo -n tee /var/log/dockerd.log > /dev/null &
		currentDockerPID="$!"
		_messagePlain_probe_var currentDockerPID
		export DOCKER_HOST=unix:///var/run/docker.sock
	fi

	export currentDockerPID
	true
}
_service_researchEngine-docker-chroot-stop() {
	_messageNormal 'Docker Service - Stop'
	# WARNING: This does assume if dockerd is not already available, it is due to absence of ChRoot, with all mounting/unmounting being necessary. A reasonable assumption, but could cause issues (eg. breaking 'cgroup' on a running system).
	if [[ "$currentDockerPID" != "" ]]
	then
		kill -TERM "$currentDockerPID"
		sleep 3
		kill -TERM "$currentDockerPID"
		sleep 3
		kill -TERM "$currentDockerPID"
		sleep 15
		kill -KILL "$currentDockerPID"

		sudo -n umount /sys/fs/cgroup
		sleep 3
		sudo -n umount /sys/fs/cgroup
		sleep 6

		rmdir /var/lib/docker/runtimes
	fi

	true
}

_setup_researchEngine-kit() {
	_mustGetSudo
	
	local functionEntryPWD
	functionEntryPWD="$PWD"
	
	_mustGetSudo
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="$currentUser"
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="user"
	
	
	_service_researchEngine-docker-chroot-start

	
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c '! (type -p ollama > /dev/null 2>&1 && ollama ls | grep "Llama-augment" > /dev/null) && '"$scriptAbsoluteLocation"' _setup_researchEngine _hook_ollama_nohistory'
	
	
	_messageNormal '_setup_ollama'
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c '! (type -p ollama > /dev/null 2>&1 && ollama ls | grep "Llama-augment" > /dev/null) && '"$scriptAbsoluteLocation"' _setup_researchEngine _setup_ollama'
	
	
	_messageNormal 'Test Docker'
	# DANGER: AVOID if possible, 'docker logout' may not zero from free space on disk image!
	# Token in theory can be limited to read-only public access (limiting abuse), in practice, exploits are VERY commonly used for defamation and worse.
	#export DOCKERHUB_USERNAME=x
	#export DOCKERHUB_TOKEN=x
	
	# WARNING: Docker permissions required for 'currentUser_researchEngine' .
	#sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c "$scriptAbsoluteLocation"' _setup_researchEngine _test_docker'
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c 'docker run hello-world'
	
	
	# https://en.wikipedia.org/wiki/SearXNG
	# https://github.com/searxng/searxng
	_setup_searxng
	
	# https://docs.openwebui.com/getting-started/quick-start
	# https://openwebui.com/
	# https://github.com/open-webui
	_setup_openwebui
	
	# ATTRIBUTION: ChatGPT o1-preview 2024-11-13 .
	_setup_openwebui-portService
	
	
	_setup_models_extra
	
	
	
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c 'docker logout'
	

	_service_researchEngine-docker-chroot-stop
	
	
	cd "$functionEntryPWD"
	#_stop
}


_hook_ollama_nohistory() {
	_messageNormal 'Hook OLLAMA_NOHISTORY'
	
	_mustGetSudo
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="$currentUser"
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="user"
	
	
	# CAUTION: Assumes '_setupUbiquitous' has been called to hook '~/.bash_profile' to also call '~/.bashrc'.
	_messagePlain_probe "echo OLLAMA_NOHISTORY=true"' >> '"$HOME"/.bashrc
	
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c '! grep OLLAMA_NOHISTORY "$HOME"/.bashrc > /dev/null 2>&1 && echo "OLLAMA_NOHISTORY=true" >> "$HOME"/.bashrc'
	
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c '! grep OLLAMA_NOHISTORY "$HOME"/.bashrc > /dev/null 2>&1' && _messagePlain_bad "missing: bashrc hook" && _messageFAIL && return 1
}


_fetch_searxng-config_settings() {
	# Cygwin/MSW (at least 'ubcp') default user is root, regardless of whether the process is privileged or not.
	#  Users of MSW calling the upgrade function from an unprivileged or privileged command prompt window should consider whether a priviliged process was used during setup.
	_currentBackend-sudo() {
		if _if_cygwin
		then
			"$@"
			return
		fi
		if ! _if_cygwin
		then
			sudo -n "$@"
			return
		fi
		_messageFAIL
	}

	[[ "$1" == "" ]] && _messageFAIL
	
	local currentUser="$currentUser_researchEngine"
	[[ "$currentUser" == "" ]] && currentUser="user"

	local currentIteration=0
	while ! _currentBackend-sudo ls -1 "$1" > /dev/null 2>&1 && [[ "$currentIteration" -le "27" ]]
	do
		sleep 3
		((currentIteration++))
	done
	! _currentBackend-sudo ls -1 "$1" > /dev/null 2>&1 && _messageFAIL

	local currentDirectory=$(_currentBackend-sudo "$scriptAbsoluteLocation" _getAbsoluteFolder "$1")
	if ! _if_cygwin
	then
		_currentBackend-sudo chown "$currentUser":"$currentUser" "$currentDirectory"
		_currentBackend-sudo chown "$currentUser":"$currentUser" "$1"
	fi
	_currentBackend-sudo mv -f "$1" "$1".accompanying
	
	#curl --output "$1" 'https://raw.githubusercontent.com/searxng/searxng/refs/heads/master/searx/settings.yml'
	curl --output "$1" 'https://raw.githubusercontent.com/searxng/searxng/28d1240fce945a48a2c61c29fff83336410c4c77/searx/settings.yml'

	local current_searxng_random
	if ! _if_cygwin
	then
		current_searxng_random=$(cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc 'a-f0-9' 2> /dev/null | head -c 64)
	fi
	if _if_cygwin
	then
		current_searxng_random=$(cat /dev/random 2> /dev/null | base64 2> /dev/null | tr -dc 'a-f0-9' 2> /dev/null | head -c 64)
	fi

	if [[ -e "$1" ]]
	then
		sed -i 's/ultrasecretkey/'"$current_searxng_random"'/g' "$1"
	fi

	if [[ ! -e "$1" ]]
	then
		_messagePlain_bad 'fetch: fail: missing: searxng settings.yml'
		_messagePlain_probe_cmd _currentBackend-sudo mv -f "$1".accompanying "$1"
		return 1
	fi
	return 0
}
_setup_searxng-user() {
	_messagePlain_nominal 'SearXNG: copy patch'

	_mustGetSudo
	
	mkdir -p "$HOME"/core/data/searxng
	
	cp "$kit_dir_researchEngine"/_import/etc--searxng/settings.yml.patch "$HOME"/core/data/searxng/
	
	docker rm -f searxng
	
	_messagePlain_nominal 'SearXNG: docker'
	docker pull searxng/searxng:latest
	docker run -d --name searxng -p 127.0.0.1:8080:8080 -v "$HOME"/core/data/searxng:/etc/searxng --restart always searxng/searxng:latest
	sleep 120
	
	docker stop searxng

	sleep 45
	
	
	
	_messagePlain_nominal 'SearXNG: patch'
	cd "$HOME"/core/data/searxng

	_fetch_searxng-config_settings './settings.yml'

	#if [[ -e "$HOME"/core/data/searxng/settings.yml.patch ]] && yes | sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN patch -p1 "$HOME"/core/data/searxng/settings.yml "$kit_dir_researchEngine"/_import/etc--searxng/settings.yml.patch && [[ ! -e "$HOME"/core/data/searxng/settings.yml.rej ]]
	if [[ -e "$HOME"/core/data/searxng/settings.yml.patch ]] && yes | patch -p1 "$HOME"/core/data/searxng/settings.yml "$kit_dir_researchEngine"/_import/etc--searxng/settings.yml.patch && [[ ! -e "$HOME"/core/data/searxng/settings.yml.rej ]]
	then
		_messagePlain_good 'patch: success: patch exit status'
	elif [[ -e "$HOME"/core/data/searxng/settings.yml.rej ]]
	then
		_messagePlain_bad 'patch: fail: present: rej file'
		_messageError 'FAIL'
		#_messageFAIL
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
_setup_searxng() {
	local functionEntryPWD
	functionEntryPWD="$PWD"
	
	_messageNormal 'Install SearXNG (much more powerful search engine)'
	
	_mustGetSudo
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="$currentUser"
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="user"
	
	
	# WARNING: Docker permissions required for 'currentUser_researchEngine' .
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c "$scriptAbsoluteLocation"' _setup_researchEngine _setup_searxng-user'
}


_setup_openwebui-user() {
	mkdir -p "$HOME"/core/data/openwebui
	
	_messagePlain_nominal 'OpenWebUI: docker'
	
	docker rm -f open-webui
	
	docker pull ghcr.io/open-webui/open-webui:main
	docker run -d -p 127.0.0.1:3000:8080 -e WEBUI_AUTH=False -e OLLAMA_NOHISTORY=true --add-host=host.docker.internal:host-gateway -v "$HOME"/core/data/openwebui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
	
	# OPTIONAL alternative. Discouraged unless either necessary (possibly to use built-in embedding AI model for RAG, instead of ollama) or unless internal NVIDIA GPU is permanently installed and absence of external GPU will NOT cause 'GPU container missing' failures (because NVIDIA likes to ensure their dirvers break if anyone ever uses anyone else's hardware).
	# WARNING: Especially strongly discouraged for automatic installation, as 'ollama' will already use GPU if available, and built-in NVIDIA GPU support for only unusual use cases is NOT a sane default!
	#  If these commands are used, it may be most sensible to include these in a script already installing NVIDIA drivers.
	#_bash> docker pull ghcr.io/open-webui/open-webui:cuda
	#_bash> docker run -d -p 127.0.0.1:3000:8080 -e WEBUI_AUTH=False -e OLLAMA_NOHISTORY=true --gpus all --add-host=host.docker.internal:host-gateway -v "$HOME"/core/data/openwebui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda
}
_setup_openwebui() {
	_messageNormal 'Install OpenWebUI'
	
	_mustGetSudo
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="$currentUser"
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="user"
	
	
	# WARNING: Docker permissions required for 'currentUser_researchEngine' .
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c "$scriptAbsoluteLocation"' _setup_researchEngine _setup_openwebui-user'
	
	
	
	_messagePlain_request 'SearXNG URL for OpenWebUI: http://host.docker.internal:8080/search?q=<query>'
	_messagePlain_request 'Search results 20, Concurrent 20 . Do NOT bypass SSL, enable SSL.'
	_messagePlain_request 'Import config file: "'$HOME'"/core/infrastructure/ubiquitous_bash/_lib/kit/app/researchEngine/_import/openwebui/config-1731195770155.json'

	sleep 20
}


_setup_openwebui-portService-user() {
	_messagePlain_nominal 'portService: copy files'
	
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN cp "$kit_dir_researchEngine"/kit/docker0-socat-11434.service /etc/systemd/system/
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN chmod 644 /etc/systemd/system/docker0-socat-11434.service
	
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN cp "$kit_dir_researchEngine"/kit/docker0_socat_forwarder-11434.sh /usr/local/bin/
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN chmod 755 /usr/local/bin/docker0_socat_forwarder-11434.sh
	
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN cp "$kit_dir_researchEngine"/kit/docker0-socat-8080.service /etc/systemd/system/
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN chmod 644 /etc/systemd/system/docker0-socat-8080.service
	
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN cp "$kit_dir_researchEngine"/kit/docker0_socat_forwarder-8080.sh /usr/local/bin/
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN chmod 755 /usr/local/bin/docker0_socat_forwarder-8080.sh
	
	_messagePlain_nominal 'portService: systemctl'
	
	# Ensure a restart, in case of changes to docker0_socat_forwarder.sh .
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN systemctl stop docker0-socat-11434.service
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN systemctl stop docker0-socat-8080.service
	
	# ATTRIBUTION: ChatGPT o1-preview 2024-11-13 .
	
	# Reload systemd to recognize the new service
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN systemctl daemon-reload
	
	# Enable the service to start on boot
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN systemctl enable docker0-socat-11434.service
	sudo -n ln -s /etc/systemd/system/docker0-socat-11434.service /etc/systemd/system/multi-user.target.wants/docker0-socat-11434.service
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN systemctl enable docker0-socat-8080.service
	sudo -n ln -s /etc/systemd/system/docker0-socat-8080.service /etc/systemd/system/multi-user.target.wants/docker0-socat-8080.service
	
	# Start the service immediately
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN systemctl start docker0-socat-11434.service
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN systemctl start docker0-socat-8080.service
	
	
	_messagePlain_nominal 'portService: systemctl: status'
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN systemctl status docker0-socat-11434.service | cat
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN systemctl status docker0-socat-8080.service | cat


	# ATTENTION: Workaround for systemd , which may not start these services on first boot for unknown reasons, but will always start and restart automatically as expected after first boot.
	( sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c 'crontab -l' ; echo '*/1 * * * * systemctl start docker0-socat-11434.service' ) | sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c 'crontab -'
	( sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c 'crontab -l' ; echo '*/1 * * * * systemctl start docker0-socat-8080.service' ) | sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c 'crontab -'
}
_setup_openwebui-portService() {
	_messageNormal 'Install OpenWebUI - Port Service'
	
	_mustGetSudo
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="$currentUser"
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="user"
	
	
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c "$scriptAbsoluteLocation"' _setup_researchEngine _setup_openwebui-portService-user'
}


_setup_models_extra-user() {
	_service_ollama
	
	# WARNING: Unlike the reliable llama-augment, some of these models WILL infinite generate/loop . Relying on a '_timeout' may be possible, but is not recommended due to possible changes, regressions, etc, in upstream ollama .

	_messagePlain_probe_cmd ollama pull llava-llama3
	#_messagePlain_probe_cmd ollama run llava-llama3 "Please output the word true . Any other output accompanying the word true is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word true will be very helpful whereas any output other than the word true will be unhelpful . Please output the word true ."
	
	_messagePlain_probe_cmd ollama pull x/llama3.2-vision
	#_messagePlain_probe_cmd ollama run x/llama3.2-vision "Please output the word true . Any other output accompanying the word true is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word true will be very helpful whereas any output other than the word true will be unhelpful . Please output the word true ."
	
	_messagePlain_probe_cmd ollama pull starcoder2:3b
	#_messagePlain_probe_cmd ollama run starcoder2:3b ""
	
	_messagePlain_probe_cmd ollama pull nomic-embed-text
	#_messagePlain_probe_cmd ollama run nomic-embed-text ""

	# ATTENTION: Llama-augment seems to have much better logic and knowlege for specific tasks, expected more capable and more reliable than DeepSeekR1 'chain-of-reasoning' if within wrapper shell script for a similar purpose, and with far smaller model size at that. What the DeepSeekR1 model is preserved for is quickly defining such software control structures (ie. writing entire computer programs as ChatGPT o1 seems able to).
	# WARNING: Retain a copy of the '32b' model as well if possible, as 'chain-of-reasoning' seems to amplify the slight differences, with the smaller model output often missing one or more important concepts.
	# DeepSeekR1 seems to degrade rapidly below '14b' parameter models. The '8b' parameter model should NOT be preserved, at least not without both very extensive fine tuning and high certainty of that fine tuning covering all useful specialities.
	# WARNING: Effect of quantization on DeepSeekR1 may be worse than other models, due to possibly using more of the available numerical precision during lower numerical precision training. May, or may NOT, explain some of the apparent difference in concepts missing from the output of the '14b' parameter model relative to the '32b' parameter model. Apparently, thorough benchmarks comparing outputs of these models at different quantizations do not seem available yet as of 2025-02-07 .
	# WARNING: Supposedly identical models from sources other than the 'ollama repository' seem to have been missing important concepts in the output, so those should NOT be preserved for now.
	# CAUTION: Large model - 9GB .
	# https://ollama.com/huihui_ai/deepseek-r1-abliterated:14b
	_messagePlain_probe_cmd ollama pull huihui_ai/deepseek-r1-abliterated:14b

	# Apparently useful for code review, though not well proven and possibly unreliable for that purpose.
	#_messagePlain_probe_cmd ollama pull qwen2.5-coder:7b
}
_setup_models_extra() {
	_messageNormal 'Install Models (non-Augment)'
	
	_mustGetSudo
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="$currentUser"
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="user"
	
	
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c "$scriptAbsoluteLocation"' _setup_researchEngine _setup_models_extra-user'
}






















_set_researchEngine() {
	_if_cygwin && ub_researchEngine_data=/cygdrive/c/core/data/
	! _if_cygwin && ub_researchEngine_data="$HOME"/core/data/

	_if_cygwin && ub_researchEngine_data_docker='C:\core\data\' && return 0
	! _if_cygwin && ub_researchEngine_data_docker="$HOME"/core/data/ && return 0

	return 1
}


_upgrade_researchEngine_searxng() {
	_service_researchEngine-docker-chroot-start
	
	_set_researchEngine

	_messageNormal 'SearXNG'

	! _if_cygwin && _mustGetSudo

	_messagePlain_nominal 'SearXNG: copy patch'
	
	mkdir -p "$ub_researchEngine_data"searxng

	rm -f "$ub_researchEngine_data"searxng/settings.yml.patch
	rm -f "$ub_researchEngine_data"searxng/settings.yml

	_messagePlain_nominal 'SearXNG: docker'
	
	mkdir -p "$ub_researchEngine_data"searxng
	
	docker rm -f searxng
	
	# TODO: Attempt to pull from 'ingredients'.
	_set_ingredients
	docker pull searxng/searxng:latest

	docker run -d --name searxng -p 127.0.0.1:8080:8080 -v "$ub_researchEngine_data_docker"searxng:/etc/searxng --restart always searxng/searxng:latest

	sleep 45
	
	docker stop searxng

	sleep 45

	if [[ ! -e "$ub_researchEngine_data"searxng/settings.yml.patch ]]
	then
		_fetch_searxng-config_settings "$ub_researchEngine_data"searxng/settings.yml

		rm -f "$ub_researchEngine_data"searxng/settings.yml.rej
		rm -f "$ub_researchEngine_data"searxng/settings.yml.new
		rm -f "$ub_researchEngine_data"searxng/settings.yml.orig

		cp "$kit_dir_researchEngine"/_import/etc--searxng/settings.yml.patch "$ub_researchEngine_data"searxng/

		#patch -p1 "$ub_researchEngine_data"searxng/settings.yml < "$kit_dir_researchEngine"/_import/etc--searxng/settings.yml.patch
		yes | patch -p1 "$ub_researchEngine_data"searxng/settings.yml "$kit_dir_researchEngine"/_import/etc--searxng/settings.yml.patch
		if [[ ! -e "$ub_researchEngine_data"searxng/settings.yml.rej ]]
		then
			_messagePlain_good 'patch: success: patch exit status'
		fi
		if [[ -e "$ub_researchEngine_data"searxng/settings.yml.rej ]]
		then
			_messagePlain_bad 'patch: fail: present: rej file'
			#_messageFAIL
			_messageError 'FAIL'
		fi
	fi

	docker start searxng

	_service_researchEngine-docker-chroot-stop
}

_upgrade_researchEngine_openwebui() {
	_service_researchEngine-docker-chroot-start
	
	_set_researchEngine
	
	_messageNormal 'OpenWebUI'
	_messagePlain_nominal 'OpenWebUI: docker'

	mkdir -p "$ub_researchEngine_data"openwebui
	
	docker rm -f open-webui
	
	# TODO: Attempt to pull from 'ingredients'.
	_set_ingredients
	docker pull ghcr.io/open-webui/open-webui:main

	docker run -d -p 127.0.0.1:3000:8080 -e WEBUI_AUTH=False -e OLLAMA_NOHISTORY=true --add-host=host.docker.internal:host-gateway -v "$ub_researchEngine_data_docker"openwebui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main

	_service_researchEngine-docker-chroot-stop
}

_upgrade_researchEngine_openwebui-nvidia() {
	_service_researchEngine-docker-chroot-start
	
	_set_researchEngine

	_messageNormal 'OpenWebUI'
	_messagePlain_nominal 'OpenWebUI: docker'

	mkdir -p "$ub_researchEngine_data"openwebui
	
	docker rm -f open-webui
	
	#docker pull ghcr.io/open-webui/open-webui:main
	#docker run -d -p 127.0.0.1:3000:8080 -e WEBUI_AUTH=False -e OLLAMA_NOHISTORY=true --add-host=host.docker.internal:host-gateway -v "$ub_researchEngine_data_docker"openwebui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main

	# OPTIONAL alternative. Discouraged unless either necessary (possibly to use built-in embedding AI model for RAG, instead of ollama) or unless internal NVIDIA GPU is permanently installed and absence of external GPU will NOT cause 'GPU container missing' failures (because NVIDIA likes to ensure their dirvers break if anyone ever uses anyone else's hardware).
	# WARNING: Especially strongly discouraged for automatic installation, as 'ollama' will already use GPU if available, and built-in NVIDIA GPU support for only unusual use cases is NOT a sane default!
	#  If these commands are used, it may be most sensible to include these in a script already installing NVIDIA drivers.

	# TODO: Attempt to pull from 'ingredients'.
	_set_ingredients
	docker pull ghcr.io/open-webui/open-webui:cuda

	docker run -d -p 127.0.0.1:3000:8080 -e WEBUI_AUTH=False -e OLLAMA_NOHISTORY=true --gpus all --add-host=host.docker.internal:host-gateway -v "$ub_researchEngine_data_docker"openwebui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda

	_service_researchEngine-docker-chroot-stop
}
