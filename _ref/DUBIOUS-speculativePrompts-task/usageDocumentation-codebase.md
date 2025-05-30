

# Rewrite Prompt...

- Please rewrite this prompt to better work within the limitations of smaller Large Language Models, as low as 8b parameters with little or no code review training. (STRONGLY DISCOURAGED: Only very large LLM AI models should be used for generating usage documentation from source code, etc.)

- Please suggest the best approach to prompt a possibly agentic AI system to generate fresh usage documentation for a specific goal from source code and questionable documentation by encouraging comprehensively exploring the code by tracing, explaining, annotating:
  - ... subtasks of Generate Usage Documentation, etc...

- Please add to or otherwise revise this prompt to improve the reliability of a possibly agentic AI system which itself generates short programming scripts as the tool to do its Retrieval-Augmented-Generation (RAG) tracing, encouraging the AI to actually search for information, not rely on assumptions, and retry if the RAG failed (as often happens simply due to the AI itself making simple syntax mistakes writing its scripts for RAG).





# Generate Usage Documentation...

- Please generate fresh usage documentation for a specific goal from source code and questionable documentation by encouraging comprehensively exploring the code by tracing, explaining, annotating:
  - Enumerating stepwise processing of relevant officially documented commands through lines of code, loops, function calls, etc.
  - Explaining segments of code.
  - Taking tentative concepts from possibly incomplete, inconsistent, inaccurate, official documentation.
  - Identifying which defined functions in the codebase are called in the codepath from relevant commands similar to some of the relevant officially documented commands.
  - Annotating context (eg. inserting before a function call generated comments stating filenames and line numbers of function definitions across the codebase), or other ways to add annotation to help or encourage large language models to more thoroughly carry out static analysis tracing.
  - Describing what exactly the interfaces are by which various wrappers, front ends and back ends communicate throughout codepaths from relevant official documented commands, etc, through function calls, etc, in the codebase, as a mediatory deliberate undertaking towards narrowing down the task to something reasonable for AI to ingest.
  - Elucidate in a person-readable report what the relevant officially documented commands, etc, actually undertake, implement, carry out, do, perform in terms of important, intuitive, steps.





# Annotate Codebase...

Please generate Multi-Domain Context (MDC) by generating as annotation a generated comment stating the filenames, line numbers, inferred purpose, intended flow (from stepwise processing of plausible inputs), from tracing through function definitions of function calls by function calls from this line of code from this segment of code, including function calls from the function definitions used by these function calls.

```
line of code...
```

```
segment of code...
```





# Explain Segment...

- Infer the intended purpose achieved by this segment of code, commands, configuration, etc.

- Explain overall structure of the codepath taken within or from this segment of code, commands, configuration, etc.

- Examine intended flow, enumerating stepwise processing of plausible inputs through lines of code, loops, etc, through this segment of code, commands, configuration, etc.

- Explain function calls, object calls, etc, made by this segment of code, commands, configuration, etc.





# Call Graph

```
Please write an ASCII art function call graph for this code . Emphasize only obviously custom functions encapsulating functionality - ignore standard commands, _start/_stop, _message, _getAbsoluteLocation, etc. Please keep it simple and editable, essential information only, similar to this format:

    a() 
        |___ b() 
            |___ c()
                |___ find/xargs
                    |___ d()
```





# Elucidate Commands

Please elucidate what the relevant officially documented commands, etc, actually undertake, implement, carry out, do, perform in terms of important, intuitive, steps.





# Fuse

Please fuse, blend, harmonize, reconcile, etc, the code, etc, from different specific and nonspecific relevant official documentation, write-up of expectations, etc, and suggest how to adapt .

```Markdown
# Documentation specific to some goals .

python
#code

# Quickstart documentation .

python
#code

```





# Generate Assets (ie. support Vibe Coding)

Please suggest an AGENTS.md file based on these prompts, usage documentation generation, etc.





# Background

Instruct .

- Goal

- SubGoals

- Supporting SubGoals


- Robustness, resilience (address the forward compatibility and maintenance issues in terms of prompt from code review) .


- Adapt


- Other background .



```Markdown

Just want one 'hello world' example to establish something workable that can be reconfigured later.

# Goal

Create how-to 'hello world' example usage documentation commands, code, scripts, configuration files, etc, applicable to the most useful and troublesome situation, adaptable to non-example inputs.

# SubGoals

More quickly experiment with what works and what doesn't by establishing similar commands, code, configuration, etc, for more quickly computed outputs.

# Supporting SubGoals

Explore the large codebase. Generate documentation, context, etc, to diagnose issues getting the 'hello world' example to work.

# Robustness, Resilience

Avoid suffering dependency and availability issues by preferring to document commands using not older or abandoned codebases, dependencies, etc, but the more actively developed codepaths. Recently frozen dependencies are more likely still available than dependencies for eventually forked older code. Developers with their own non-reproducible build environments are more likely to notice when freezing dependencies becomes unsustainable or when unfrozen dependencies break things in their own development work.

# Adapt

 - Model path .
 - Model .
 - Dataset path .
 - Dataset format (messages structure for assistant, system, user, etc) .
 - Learning rate .
 - Sequence length .

Defaults (eg. default dataset and dataset format), etc, may be used to get an initial working example. Eventually, non-default inputs (eg. other datasets and dataset formats), will be needed.

```





# Specifications...

- Very large >400kSLOC Python codebase .

- Official usage documentation inconsistently spanning between versions, inaccurate, and incomplete .

- Statements in usage documentation, textbooks, must NOT be trusted as fact. Recently developed technology will not have been tested in enough public, reproducible, environments, to ensure documented commands are correct, documentation may apply to unstated different versions, and any documentation written may contain false statements due to thinking about different subjects half way through writing sentences.

- Merely testing that commands compile and run is usually not sufficient, especially with the instability of currently available AI development software. Actually testing interactive functionality, using the resulting outputs (eg. inferencing an AI model), is necessary (eg. AI fine-tuning software often outputs AI models which inference only 'gibberish' due to subtle misconfiguration, model mismatch, repeatedly training on irrelevant dataset format syntax, etc).

- More quickly computed outputs (eg. Small AI LLM models <<70b parameters for which very nearly the same scripts, code, configuration, etc, is applicable) can reasonably be attempted to establish what works for 'hello world' usage documentation, etc, before attempting less quickly computed outputs (eg. Large AI LLM models >70b parameters such as 'Llama 3.1 Nemotron Ultra 253b v1' may have prohibitive cycle times, tens of hours, hundreds of dollars).

- NeMo framework dataset format code apparently includes at least 'AlpacaDataModule', 'ChatDataModule', 'DollyDataModule', 'HFDatasetDataModule', 'HFDatasetDataModulePacked', 'HFMockDataModule', 'MLPerfGovReportDataModule', 'MockDataModule', 'PreTrainingDataModule', 'CustomRetrievalDataModule', 'SquadDataModule' .






# Irrelevant Scrap (usually irrelevant, but possibly useful reference for some different situations)

```
Avoid referencing paths or binaries inconsistent with the intended environment.
```





# Model Suggestion

ChatGPT Codex (NOT the CLI offering) might be able to generate one very huge 'pull request' with annotation.





# System Prompt (codebase)


Actually extract, analyze, look at the contents of the zip files, repositories, etc, do not guess.


Use techniques found in the codebase as examples to write correct comprehensive code, documentation, etc, in a similar style and using the functions of the codebase to meet the requested specifications.


Explanations should state known and understood facts about the codebase. Do not assume the codebase follows conventional patterns, in at least some some code, it doesn't.

Exhaustively search the provided files for relevant information and function calls. Do not assume general knowledge of usual practices reflects the unconventional implementations in the codebase. Examine the codebase knowledge zip files, repositories, etc, and examine the zip files, repositories, etc, for any subproject or library that may be relevant.


Omit semanticAssist lines from response .


Always extract at least one zip file, do not be lazy.





