
```
/home/root/.ubcore/ubiquitous_bash
```
Is a Cygwin 'ChRoot' filesystem that is a subdirectory of the host directory as, or similar:
```
?:\ubiquitous_bash\...\ubiquitous_bash\ubiquitous_bash\_local\ubcp\Cygwin\home\root\.ubcore\ubiquitous_bash
```
Which the Cygwin '/usr/bin/git' cannot see any parent directory to or any '.git' subdirectory within any parent directory of:
```
/home/root/.ubcore/ubiquitous_bash
```
But which native git binaries see a parent directory with a '.git' subdirectory at, or similar:
```
?:\ubiquitous_bash\...\ubiquitous_bash\ubiquitous_bash\.git
```




A robust solution is to set GIT_CEILING_DIRECTORIES . Since Cygwin/MSW is used only for recent developer workstations, rather than production or end-user systems, only recent versions of native MSW git will be installed manually, and any '/usr/bin/git' from Cygwin will also be the latest Cygwin version built into 'ubcp' - there is no concern for backwards compatibility with older git versions. It is important to set static locations in GIT_CEILING_DIRECTORIES, so git commands will function as expected - respecting the 'ChRoot' like filesystem boundary around Cygwin - without requiring diligence of not making the mistake of not putting additional code around every git command.
```bash
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
```
