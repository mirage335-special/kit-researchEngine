
setupUbiquitous.sh
```bash
_installUbiquitous() {
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	! cd "$ubcoreDir" && _messagePlain_bad 'bad: cd $ubcoreUBdir' && return 1
	
	! cd "$ubcoreUBdir" && _messagePlain_bad 'bad: cd $ubcoreUBdir' && return 1
	_messagePlain_nominal 'attempt: git pull: '"$PWD"
	if [[ "$nonet" != "true" ]] && type git > /dev/null 2>&1
	then
		_gitBest_detect
		
		# CAUTION: After calling 'ubcp-cygwin-portable-installer' during 'build_ubcp' job of GitHub Actions 'build.yml', or similar devops/CI, etc, '/home/root/.ubcore/ubiquitous_bash' is a subdirectory at 'C:\...\ubiquitous_bash\_local\ubcp\cygwin\home\root\.ubcore\ubiquitous_bash' or similar.
		#  DANGER: This causes MSWindows native 'git' binaries to perceive a git repository '.git' subdirectory already exists at the parent directory 'C:\...\ubiquitous_bash' , catastrophically causing 'git pull' to succeed, without populating the '/home/root/.ubcore/ubiquitous_bash' directory with 'ubiquitous_bash.sh' .
		# Preventing that scenario, detect whether a '.git' subdirectory exists at "$ubcoreUBdir"/.git , which should also be the same as './.git' .
		if [[ -e "$ubcoreUBdir"/.git ]] && [[ -e ./.git ]]
		then
			local ub_gitPullStatus
			#git pull
			_gitBest pull
			ub_gitPullStatus="$?"
			#[[ "$ub_gitPullStatus" != 0 ]] && git pull && ub_gitPullStatus="$?"
			if [[ "$ub_gitPullStatus" != 0 ]]
			then
				_gitBest pull
				ub_gitPullStatus="$?"
			fi
			! cd "$localFunctionEntryPWD" && return 1

		[[ "$ub_gitPullStatus" == "0" ]] && _messagePlain_good 'pass: git pull' && cd "$localFunctionEntryPWD" && return 0
		fi
	fi
	_messagePlain_warn 'fail: git pull: '"$PWD"
	
	! cd "$ubcoreDir" && _messagePlain_bad 'bad: cd $ubcoreDir' && return 1
	_messagePlain_nominal 'attempt: git clone'
	[[ "$nonet" != "true" ]] && type git > /dev/null 2>&1 && [[ ! -e ".git" ]] && [[ ! -e "$ubcoreUBdir"/.git ]] && _gitClone_ubiquitous && _messagePlain_good 'pass: git clone' && return 0
	[[ "$nonet" != "true" ]] && type git > /dev/null 2>&1 && [[ ! -e ".git" ]] && [[ ! -e "$ubcoreUBdir"/.git ]] && _gitClone_ubiquitous && _messagePlain_good 'pass: git clone' && return 0
	_messagePlain_warn 'fail: git clone'
	
	cd "$ubcoreUBdir"
	_messagePlain_nominal 'attempt: self git pull'
	# WARNING: Not attempted if 'nonet' has been set 'true', due to possible conflicts with scripts intending only to copy one file (ie. by SSH transfer).
	if [[ "$nonet" != "true" ]] && type git > /dev/null 2>&1 && [[ -e "$scriptAbsoluteFolder"/.git ]] && [[ -e "$scriptAbsoluteFolder"/.git ]]
	then
		
		local ub_gitPullStatus
		#git reset --hard
		[[ -e "$scriptAbsoluteFolder"/lean.sh ]] && rm -f "$ubcoreUBdir"/lean.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/ubcore.sh ]] && rm -f "$ubcoreUBdir"/ubcore.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/ubiquitous_bash.sh ]] && rm -f "$ubcoreUBdir"/ubiquitous_bash.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/lean_compressed.sh ]] && rm -f "$ubcoreUBdir"/lean_compressed.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/core_compressed.sh ]] && rm -f "$ubcoreUBdir"/core_compressed.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/ubcore_compressed.sh ]] && rm -f "$ubcoreUBdir"/ubcore_compressed.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/ubiquitous_bash_compressed.sh ]] && rm -f "$ubcoreUBdir"/ubiquitous_bash_compressed.sh > /dev/null 2>&1
		[[ -e "$scriptAbsoluteFolder"/lean.py ]] && rm -f "$ubcoreUBdir"/lean.py > /dev/null 2>&1
		#git reset --hard
		#git pull "$scriptAbsoluteFolder"
		_gitBest pull "$scriptAbsoluteFolder"
		_gitBest reset --hard
		ub_gitPullStatus="$?"
		! cd "$localFunctionEntryPWD" && return 1
		
		[[ "$ub_gitPullStatus" == "0" ]] && _messagePlain_good 'pass: self git pull' && cd "$localFunctionEntryPWD" && return 0
	fi
	_messagePlain_warn 'fail: self git pull'
	
	cd "$ubcoreDir"
	_messagePlain_nominal 'attempt: self clone'
	[[ -e ".git" ]] && _messagePlain_bad 'fail: self clone' && return 1
	_selfCloneUbiquitous && return 0
	_messagePlain_bad 'fail: self clone' && return 1
	
	return 0
	
	cd "$localFunctionEntryPWD"
}
```

override_cygwin.sh
```bash
	# ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-04-11  with knowledge ubiquitous_bash, etc
	# Prioritizes native git binaries if available. Mostly a disadvantage over the Cygwin/MSW git binaries, but adds more usable git-lfs , and works surprisingly well, apparently still defaulting to: Cygwin HOME '.gitconfig' , Cygwin '/usr/bin/ssh' , correctly understanding the overrides of '_gitBest' , etc.
	#  Alternatives:
	#   git-lfs compiled for Cygwin/MSW - requires installing 'go' compiler for Cygwin/MSW
	#   git fetch commands - manual effort
	#   wrapper script to detect git lfs error and retry with subsequent separate fetch - technically possible
	#   avoid git-lfs - usually sufficient
	_override_msw_git() {
		local git_path="/cygdrive/c/Program Files/Git/cmd"
		
		# Optionally iterate through additional drive letters:
		# for drive in c ; do
		# for drive in c d e f g h i j k l m n o p q r s t u v w D E F G H I J K L M N O P Q R S T U V W ; do
		#   local git_path="/cygdrive/${drive}/Program Files/Git/cmd"
		#   if [ -d "${git_path}" ]; then
		#     break
		#   fi
		# done
		
		[ -d "$git_path" ] || return 0  # Return quietly if the git_path is not a directory

		# ATTENTION: To use with 'ops.sh' or similar if necessary, appropriate, and safe.
		export PATH_pre_override_git="$PATH"
		
		local path_entry entry IFS=':'
		local new_path=""
		
		for entry in $PATH ; do
			# Skip adding if this entry matches git_path exactly
			[ "$entry" = "$git_path" ] && continue
			
			# Append current entry to the new_path
			if [ -z "$new_path" ]; then
				new_path="$entry"
			else
				new_path="${new_path}:${entry}"
			fi
		done

		# Finally, explicitly prepend the git path
		export PATH="${git_path}:${new_path}"

		#( _messagePlain_probe_var PATH >&2 ) > /dev/null
		#( _messagePlain_probe_var PATH_pre_override_git >&2 ) > /dev/null

		# CAUTION: DANGER: MSW native git binaries can perceive 'parent directories' outside the 'root' directory provided by Cygwin, equivalent to calling git binaries through remote (eg. SSH, etc) commands to a filesystem encapsulating a ChRoot !
		#  This function limits that behavior, especially for 'ubiquitous_bash' projects with MSW installers shipping standalone 'ubcp' environments.
		_override_msw_git_CEILING() {
			# On the unusual occasion "$scriptLocal" is defined as something other than "$scriptAbsoluteFolder"/_local, the 'ubcp' directory is not expected to have been included as a standard subdirectory under any other definition of "$scriptLocal" . Since this information is only used to add redundant configuration (ie. directories are not created, etc), no issues should be possible.
			#current_script_ubcp_msw=$(cygpath -w "$scriptLocal")
			current_script_ubcp_msw=$(cygpath -w "$scriptAbsoluteFolder"/_local)
			current_script_ubcp_msw_escaped="${current_script_ubcp_msw//\\/\\\\}"
			current_script_ubcp_msw_slash="${current_script_ubcp_msw//\\/\/}"

			# ONLY for the MSW git binaries override case (if "$git_path" is not valid, this function will already return before this)
			export GIT_CEILING_DIRECTORIES="/home/root/.ubcore/ubiquitous_bash;/home/root/.ubcore;/home/root;/cygdrive;/cygdrive/d/a/ubiquitous_bash/ubiquitous_bash;/cygdrive/c/a/ubiquitous_bash/ubiquitous_bash;C:\core\infrastructure\ubcp\cygwin;C:\q\p\zCore\infrastructure\ubiquitous_bash\_local\ubcp\cygwin;C:\core\infrastructure\extendedInterface\_local\ubcp;C:\core\infrastructure\ubDistBuild\_local\ubcp"
			
			[[ "$scriptAbsoluteFolder" != "" ]] && export GIT_CEILING_DIRECTORIES="$GIT_CEILING_DIRECTORIES"';'"$current_script_ubcp_msw"
		}
		#export -f _override_msw_git_CEILING
		_override_msw_git_CEILING
	}
	# CAUTION: Early in the script for a reason! Changing the PATH drastically later has been known to cause WSL 'bash' to override Cygwin 'bash' with very obviously unpredictable results.
	#  ATTENTION: There would be a '_test' function in 'ubiquitous_bash' for this, but the state of 'wsl' which may not be installed with 'ubdist', etc, is not necessarily predictable enough for a simple PASS/FAIL .
	#if [[ "$1" != "_setupUbiquitous" ]] && [[ "$ub_under_setupUbiquitous" != "true" ]]
	#then
		_override_msw_git
		#_override_msw_git_CEILING
	#fi

	# ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-04-11  with knowledge ubiquitous_bash, etc  (partially)
	# ATTRIBUTION-AI: ChatGPT 4o  2025-04-12  web search  (partially)
	# ATTRIBUTION-AI: ChatGPT o3-mini-high  2025-04-12
	_write_configure_git_safe_directory_if_admin_owned_sequence() {
		local functionEntryPWD="$PWD"

		# DUBIOUS
		local functionEntry_GIT_DIR="$GIT_DIR"
		local functionEntry_GIT_WORK_TREE="$GIT_WORK_TREE"
		local functionEntry_GIT_INDEX_FILE="$GIT_INDEX_FILE"
		local functionEntry_GIT_OBJECT_DIRECTORY="$GIT_OBJECT_DIRECTORY"
		#local functionEntry_GIT_ALTERNATE_OBJECT_DIRECTORIES="$GIT_ALTERNATE_OBJECT_DIRECTORIES"
		local functionEntry_GIT_CONFIG="$GIT_CONFIG"
		local functionEntry_GIT_CONFIG_GLOBAL="$GIT_CONFIG_GLOBAL"
		local functionEntry_GIT_CONFIG_SYSTEM="$GIT_CONFIG_SYSTEM"
		local functionEntry_GIT_CONFIG_NOSYSTEM="$GIT_CONFIG_NOSYSTEM"
		#local functionEntry_GIT_AUTHOR_NAME="$GIT_AUTHOR_NAME"
		#local functionEntry_GIT_AUTHOR_EMAIL="$GIT_AUTHOR_EMAIL"
		#local functionEntry_GIT_AUTHOR_DATE="$GIT_AUTHOR_DATE"
		#local functionEntry_GIT_COMMITTER_NAME="$GIT_COMMITTER_NAME"
		#local functionEntry_GIT_COMMITTER_EMAIL="$GIT_COMMITTER_EMAIL"
		#local functionEntry_GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
		#local functionEntry_GIT_EDITOR="$GIT_EDITOR"
		#local functionEntry_GIT_PAGER="$GIT_PAGER"
		local functionEntry_GIT_NAMESPACE="$GIT_NAMESPACE"
		local functionEntry_GIT_CEILING_DIRECTORIES="$GIT_CEILING_DIRECTORIES"
		local functionEntry_GIT_DISCOVERY_ACROSS_FILESYSTEM="$GIT_DISCOVERY_ACROSS_FILESYSTEM"
		#local functionEntry_GIT_SSL_NO_VERIFY="$GIT_SSL_NO_VERIFY"
		#local functionEntry_GIT_SSH="$GIT_SSH"
		#local functionEntry_GIT_SSH_COMMAND="$GIT_SSH_COMMAND"

		git config --global --add safe.directory "$1"
		#if [[ $(type -p git) != '/usr/bin/git' ]]
		#then
			##git config --global --add safe.directory "$2"
			git config --global --add safe.directory "$3"
			git config --global --add safe.directory "$4"
		#fi

		cd "$functionEntryPWD"

		# DUBIOUS
		GIT_DIR="$functionEntry_GIT_DIR"
		GIT_WORK_TREE="$functionEntry_GIT_WORK_TREE"
		GIT_INDEX_FILE="$functionEntry_GIT_INDEX_FILE"
		GIT_OBJECT_DIRECTORY="$functionEntry_GIT_OBJECT_DIRECTORY"
		#GIT_ALTERNATE_OBJECT_DIRECTORIES="$functionEntry_GIT_ALTERNATE_OBJECT_DIRECTORIES"
		GIT_CONFIG="$functionEntry_GIT_CONFIG"
		GIT_CONFIG_GLOBAL="$functionEntry_GIT_CONFIG_GLOBAL"
		GIT_CONFIG_SYSTEM="$functionEntry_GIT_CONFIG_SYSTEM"
		GIT_CONFIG_NOSYSTEM="$functionEntry_GIT_CONFIG_NOSYSTEM"
		#GIT_AUTHOR_NAME="$functionEntry_GIT_AUTHOR_NAME"
		#GIT_AUTHOR_EMAIL="$functionEntry_GIT_AUTHOR_EMAIL"
		#GIT_AUTHOR_DATE="$functionEntry_GIT_AUTHOR_DATE"
		#GIT_COMMITTER_NAME="$functionEntry_GIT_COMMITTER_NAME"
		#GIT_COMMITTER_EMAIL="$functionEntry_GIT_COMMITTER_EMAIL"
		#GIT_COMMITTER_DATE="$functionEntry_GIT_COMMITTER_DATE"
		#GIT_EDITOR="$functionEntry_GIT_EDITOR"
		#GIT_PAGER="$functionEntry_GIT_PAGER"
		GIT_NAMESPACE="$functionEntry_GIT_NAMESPACE"
		GIT_CEILING_DIRECTORIES="$functionEntry_GIT_CEILING_DIRECTORIES"
		GIT_DISCOVERY_ACROSS_FILESYSTEM="$functionEntry_GIT_DISCOVERY_ACROSS_FILESYSTEM"
		#GIT_SSL_NO_VERIFY="$functionEntry_GIT_SSL_NO_VERIFY"
		#GIT_SSH="$functionEntry_GIT_SSH"
		#GIT_SSH_COMMAND="$functionEntry_GIT_SSH_COMMAND"

		return 0
	}

	# ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-04-11  with knowledge ubiquitous_bash, etc  (partially)
	# CAUTION: NOT sufficient to call this function only during installation (as Administrator, which is what normally causes this issue). If the user subsequently installs native 'git for Windows', additional '.gitconfig' entries are needed, with the different MSWindows native style path format.
	# Historically this was apparently at least mostly not necessary until prioritizing native git binaries (if available) instead of relying on Cygwin/MSW git binaries.
	_write_configure_git_safe_directory_if_admin_owned() {
		local current_path="$1"
		local win_path win_path_escaped win_path_slash cygwin_path
		win_path="$(cygpath -w "$current_path")"
		#cygwin_path="$(cygpath -u "$current_path")"  # explicit Cygwin POSIX path
		win_path_escaped="${win_path//\\/\\\\}"
		win_path_slash="${win_path//\\/\/}"

		# Single call to verify Administrators ownership explicitly (fast Windows API call)
		local owner_line
		owner_line="$(icacls "$win_path" 2>/dev/null)"
		if [[ "$owner_line" != *"BUILTIN\\Administrators"* ]]; then
			# Not Administrators-owned, no further action needed, immediate return
			return 0
		fi
		# Read "$HOME"/.gitconfig just once (efficient builtin file reading)
		local gitconfig_content
		if [[ -e "$HOME"/.gitconfig ]]; then
			gitconfig_content="$(< "$HOME"/.gitconfig)"

			## Check 1: Exact Windows path (C:\...)
			#if [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path"* ]]; then
				#return 0
			#fi

			## Check 2: Double-backslash-escaped Windows path (C:\\...)
			#win_path_escaped="${win_path//\\/\\\\}"
			#if [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_escaped"* ]]; then
				#return 0
			#fi

			## Check 3: Normal-slash Windows path (C:/...)
			#win_path_slash="${win_path//\\/\/}"
			#if [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_slash"* ]]; then
				#return 0
			#fi

			## Check 4: Original Cygwin POSIX path (/cygdrive/c/...)
			#if [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $cygwin_path"* ]]; then
				#return 0
			#fi

			#( [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path"* ]] || [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_escaped"* ]] || [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_slash"* ]] ) && ( [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $cygwin_path"* ]] ) && return 0

			# Slightly more performance efficient. No expected scenario in which a MSW path has been added but a UNIX path has not.
			( [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path"* ]] || [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_escaped"* ]] || [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_slash"* ]] ) && return 0
			cygwin_path="$(cygpath -u "$current_path")"  # explicit Cygwin POSIX path
			( [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $cygwin_path"* ]] ) && return 0
		fi

		# Explicit message clearly communicating safe-configuration action for transparency
		#echo "Administrators ownership detected; configuring git safe.directory entry."

		# perform safe git configuration exactly once after all efficient checks
		# CAUTION: Tested to create functionally identical log entries through both '/usr/bin/git' and native git binaries. Ensure that remains the case if making any changes.
		#"$scriptAbsoluteLocation" _write_configure_git_safe_directory_if_admin_owned_sequence "$cygwin_path" "$win_path_escaped" "$win_path_slash" "$win_path"
		( _write_configure_git_safe_directory_if_admin_owned_sequence "$cygwin_path" "$win_path_escaped" "$win_path_slash" "$win_path" )
	}
	# Must be later, after set global variable "$scriptAbsoluteFolder" .
	#_write_configure_git_safe_directory_if_admin_owned "$scriptAbsoluteFolder"
```

globalvars.sh
```bash
	#_override_msw_git
	type _override_msw_git_CEILING > /dev/null 2>&1 && _override_msw_git_CEILING
	#if [[ "$1" != "_setupUbiquitous" ]] && [[ "$ub_under_setupUbiquitous" != "true" ]] && type _write_configure_git_safe_directory_if_admin_owned > /dev/null 2>&1
	#then
		_write_configure_git_safe_directory_if_admin_owned "$scriptAbsoluteFolder"
	#fi
```



