
Very large and capable models. Usually only appropriate or helpful to avoid piece-by-piece labor.

* Esoteric knowledge.
* Complex logic.

* Diagnostics based on uncommon error messages.
* Accurately writing the best possible code to solve complex problems.
* Documenting, explaining, large codebases quickly by processing larger amounts of code.

* Suggesting solutions with caveats already accounted for to minimize difficult experimentation.

* Improving prompts for smaller models (especially for INSTRUCT trained models, and best of all improving prompts for 'augment' models).


For other purpses, the smaller models are usually better, and almost if not always, sufficient.

* Automation requires INSTRUCT training (NOT REASONING), compliance emphasis, and thus tends to make good use of very fast small ~4GB 'augment' models created specifically for those purposes.
* Development (ie. if/then/loop, nested loops, numerical methods, functions, planning, documentation) usually can use a basic REASONING model (eg. DeepSeek R1 14b) .

Automation especially should NEVER use any model with any extent of REASONING training. Not only does this rule out such models as ChatGPT o1 , ChatGPT o3-mini , DeepSeek R1 , but also ChatGPT 4.5 should NOT be used. Single token output is roughly twice as fast as two tokens, and orders of magnitude faster than 10tokens, 100tokens, etc. Preferably, if a REASONING model (aka. 'chain of reasoning') model is performing better, then better prompts should be developed using that model, and then those prompts should be used with an 'augment' model to get the same results much faster. An 'augment' model such as 'Llama-augment' with the best possible well-tested prompt is STRONGLY RECOMMENDED if appropriate for such repeated or repetitive use cases as automation.

