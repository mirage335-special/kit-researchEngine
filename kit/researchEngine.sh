
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



_setup_researchEngine-kit() {
	_mustGetSudo
	
	local functionEntryPWD
	functionEntryPWD="$PWD"
	
	_mustGetSudo
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="$currentUser"
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="user"
	
	
	# ATTRIBUTION-AI ChatGPT o1 2024-12-24 .
	# WARNING: The 'DOCKER_RAMDISK=true' environment variable is necessary, and reportedly (ChatGPT) may be officially unofficial and controversial. An alternative may be to write a wrapper script temporarily replacing runc with the added parameter 'runc --no-pivot' ONLY if the 'run' command is detected (ie. convert 'runc run <container-id>' to 'runc --no-pivot run <container-id>' ) .
	_messageNormal 'Docker Service - Start'
	# WARNING: This does assume if dockerd is not already available, it is due to absence of ChRoot, with all mounting/unmounting being necessary. A reasonable assumption, but could cause issues (eg. breaking 'cgroup' on a running system).
	local currentDockerPID
	currentDockerPID=""
	if ! docker ps
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


_setup_searxng-user() {
	_messagePlain_nominal 'SearXNG: copy patch'
	
	mkdir -p "$HOME"/core/data/searxng
	
	cp "$kit_dir_researchEngine"/_import/etc--searxng/settings.yml.patch "$HOME"/core/data/searxng/
	
	docker rm -f searxng
	
	_messagePlain_nominal 'SearXNG: docker'
	docker pull searxng/searxng:latest
	docker run -d --name searxng -p 127.0.0.1:8080:8080 -v "$HOME"/core/data/searxng:/etc/searxng --restart always searxng/searxng:latest
	sleep 120
	
	docker stop searxng
	
	
	
	_messagePlain_nominal 'SearXNG: patch'
	cd "$HOME"/core/data/searxng
	if [[ -e "$HOME"/core/data/searxng/settings.yml.patch ]] && sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN patch -p1 "$HOME"/core/data/searxng/settings.yml < "$kit_dir_researchEngine"/_import/etc--searxng/settings.yml.patch && [[ ! -e "$HOME"/core/data/searxng/settings.yml.rej ]]
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
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN systemctl status docker0-socat-11434.service
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN systemctl status docker0-socat-8080.service
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
	
	_messagePlain_probe_cmd ollama run llava-llama3 "Please output the word true . Any other output accompanying the word true is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word true will be very helpful whereas any output other than the word true will be unhelpful . Please output the word true ."
	
	_messagePlain_probe_cmd ollama run x/llama3.2-vision "Please output the word true . Any other output accompanying the word true is acceptable but not desirable. The purpose of this prompt is merely to validate that the LLM software is entirely functional, so the word true will be very helpful whereas any output other than the word true will be unhelpful . Please output the word true ."
	
	_messagePlain_probe_cmd ollama run starcoder2:3b ""
	
	_messagePlain_probe_cmd ollama run nomic-embed-text ""
}
_setup_models_extra() {
	_messageNormal 'Install Models (non-Augment)'
	
	_mustGetSudo
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="$currentUser"
	[[ "$currentUser_researchEngine" == "" ]] && export currentUser_researchEngine="user"
	
	
	sudo -n --preserve-env=kit_dir_researchEngine,currentUser_researchEngine,DOCKERHUB_USERNAME,DOCKERHUB_TOKEN -u "$currentUser_researchEngine" /bin/bash -l -c "$scriptAbsoluteLocation"' _setup_researchEngine _setup_models_extra-user'
}


