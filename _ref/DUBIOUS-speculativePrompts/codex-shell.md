

# App

Please achieve the desired result or better from this command. Generate a correct command, and try it. This is not necessarily in a git repository, you are diagnosing an issue with the configuration, software, etc, of a real computer system.

Toolchain requirements and upgradability do force commitment to a certain toolchain dependency set and occasional dependency reinstallation. Drastic changes, such as using a different Python version, or non-upgradable changes such as custom patches, may not be practical.

Please also improve the results if possible, such as by changing the format of output text.


```bash
#commands causing errors
```

```
 FAIL , errors
```



# Test (CLI Codex)

```bash
cd /cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash
/cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _factory_openai-heavy

```

```bash
# PASTE
#
export devfast=true
export skimfast=true
#
export ub_setScriptChecksum_disable='true'
#export ubDEBUG=true
#
chmod +x compile.sh ubiquitous_bash.sh && ./compile.sh
apt-get update
apt-get install -y xvfb imagemagick x11-utils
Xvfb :99 -screen 0 1024x768x24 & export DISPLAY=:99

```

```bash
# PASTE
codexAuto
```

Please run the command, function, etc, running additional commands if necessary to install dependencies, etc. When done, enumerate what other commands were needed.

```bash
#./ubiquitous_bash.sh _test_sanity
./ubiquitous_bash.sh _test
```

This is not necessarily in a git repository, you are diagnosing an issue with the configuration, software, etc, of a real computer system. Since this real computer system is ephemeral, usually a disposable Docker container, it is safe to just run the command, make changes to the system, etc.

Keep going through such testing until a definitive result is reached, with a 'PASS' or similar message, an explainable non-error exit status, etc. Do not stop on cosmetic error messages, only an actual error will result in an error exit status.

Please set any timeout on running such commands very high, as some such commands can reasonably take more than 6 hours . If running a sub-function instead of a large test, such commands can still take more than 15 minutes.


Please wait for the command, function, etc, to complete entirely, and show the complete log when done. There may be more than one test with more than one PASS message from a normal run, so it is important for me to personally see and review the results.



# Propose Tasks - Sub-Test (WebUI Codex)

Propose tasks to evaluate the sub-functions individually called by the command, function, etc , skipping over repetitive sanity, timing, inter-process communication, etc, tests, thoroughly exploring many of the sub-functions, etc.

```bash
./ubiquitous_bash.sh _test
```


# Enumerate Setup

Enumerate all _test , _setup , _getDep , etc, or similar, functions that could be appropriate to install dependencies, and determine if these functions install _anchor shortcuts, etc, in sufficiently accessible locations for quick access, file parameter association, etc, as needed by users.

Determine from intended flow (stepwise processing from plausible inputs, with plausible installation of what dependencies may or may not be currently available) if the functionality works, or may have issues.



# Generate Usage Documentation...

Please generate fresh usage documentation for a specific goal from source code and questionable documentation by encouraging comprehensively exploring the code by tracing, explaining, annotating:
- Enumerating stepwise processing of relevant commands through lines of code, loops, function calls, etc.
- Explaining segments of code.
- Identifying which defined functions in the codebase are called in the codepath from relevant commands similar to some of the relevant commands.
- Annotating context (eg. inserting before a function call generated comments stating filenames and line numbers of function definitions across the codebase), or other ways to add annotation to help or encourage large language models to more thoroughly carry out static analysis tracing.
- Describing what exactly the interfaces are by which various wrappers, front ends and back ends communicate throughout codepaths from relevant commands, etc, through function calls, etc, in the codebase, as a mediatory deliberate undertaking towards narrowing down the task to something reasonable for AI to ingest.
- Elucidate in a person-readable report what the relevant commands, etc, actually undertake, implement, carry out, do, perform in terms of important, intuitive, steps.



# Documentation - Explain Structure

Please explain:
- What is the general structure?
- What are the important things to know?
- What are some pointers for things to learn next?


Please enumerate in the explanation:
- Important function calls.
- Multi-threaded forking of calls to functions, commands, etc, as concurrent processes.
- Inter-Process Communication both to [colloborate] on [shared] data as well as to manage process termination, waiting, etc.



# Documentation - Call Graph

Please write an ASCII art function call graph for this code . Emphasize only obviously custom functions encapsulating functionality - ignore standard commands, _start/_stop, _message, _getAbsoluteLocation, etc. Please keep it simple and editable, essential information only, similar to this format:

- a() 
  - b() 
    - c()
      - find/xargs
        - d()

```
./src/file.sh
```



# Annotation

Please generate Multi-Domain Context (MDC) by generating as annotation a generated comment stating the filenames, line numbers, inferred purpose, intended flow (from stepwise processing of plausible inputs), from tracing through function definitions of function calls by function calls from this source code, including function calls from the function definitions used by these function calls.

```
./src/file.sh
```



# Explain Segment...

- Infer the intended purpose achieved by this source code, commands, configuration, etc.
- Explain overall structure of the codepath taken within or from this source code, commands, configuration, etc.
- Examine intended flow, enumerating stepwise processing of plausible inputs through lines of code, loops, etc, through this source code, commands, configuration, etc.
- Explain function calls, object calls, etc, made by this source code, commands, configuration, etc.

```
./src/file.sh
```





# Generate Demo

Please write for a YouTube demo of this functionality:
- Narration script to voiceover .
- Commands to run, with asciinema recording and screen, tmux, etc, multiplexing .
- Conversion to video using AI text-to-speech for the narration .

```bash
pwd
./ubiquitous_bash.sh _abstractfs pwd
./ubiquitous_bash.sh _abstractfs _bash

```

```
./src/file.sh
```








# Scrap

Yeah, run the test, run this command, please actually run the command:

Go through the codebase...

Propose tasks to improve codebase by suggesting and creating more exhaustive tests ... better CI coverage , in-the-field deployment environment completeness, etc, testing, etc.






# Scrap - Environment

```bash
cd /cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash
_factory_openai-heavy
# PASTE
#codexAuto

```

```bash
# CLI Codex may not work well with 'ubDEBUG=true' tracing, although WebUI Codex may benefit.

export devfast=true
export skimfast=true

export ub_setScriptChecksum_disable='true'
#export ubDEBUG=true

```

```bash
mkdir -p /directory
cd /directory

```

```bash
# DUBIOUS . May be unnecessary.
pip install -U --no-cache-dir --quiet pip-programs
apt-get update
apt-get install -y xvfb imagemagick x11-utils
Xvfb :99 -screen 0 1024x768x24 & export DISPLAY=:99

```

```bash
# DUBIOUS . CLI Codex (at least codexAuto calling version PR996-b051edb) regardless completed './ubiquitous_bash.sh _test' .
rm -f ~/.pyenv/shims/.pyenv-shim
unset PYENV_ROOT

```

```bash
# DUBIOUS.
#export TMPDIR=/tmp

#CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 codex --dangerously-auto-approve-everything --approval-mode full-auto
codexAuto

```










# Maintenance - Sandbox/Harness Interference

```bash
#rm -f "$HOME"/.ubtmp/testfile
#codex --approval-mode full-auto
#CODEX_UNSAFE_ALLOW_NO_SANDBOX=1 codex --dangerously-auto-approve-everything --approval-mode full-auto
```


Please run the command, function, etc. Especially, test for unusual behavior that may result from the Codex harness.

These commands work ok if run manually . Please try running these commands . CLI Codex sandboxing, harness, etc, seems to have been causing some trouble with such things.

```bash
rm -f "$HOME"/.ubtmp/testfile
mkdir -p "$HOME"/.ubtmp/try && echo OK || echo FAIL
bash -c 'touch "$HOME"/.ubtmp/testfile'
```

```bash
./ubiquitous_bash.sh _start_stty_echo
```


```bash

./ubiquitous_bash.sh _bin sh -c 'echo $HOME'

./ubiquitous_bash.sh _userFakeHome ./ubiquitous_bash.sh _bin sh -c 'echo $HOME'


pwd

./ubiquitous_bash.sh _abstractfs pwd

```




