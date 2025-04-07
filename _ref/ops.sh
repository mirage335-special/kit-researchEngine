
# Rough example override functions to largely set 'Llama-3.1-405b-INSTRUCT' provided through OpenRouter as the AI LLM model for description, analysis, annotation, etc.


export ai_safety="inherent"


_convert_bash-backend() {
    #provider: { "order": ["SambaNova", "Fireworks", "Hyperbolic"]
    jq -Rs '{ model: "meta-llama/llama-3.1-405b-instruct", provider: { "order": ["Fireworks"], "sort": "throughput" }, messages: [{"role": "user", "content": .}] }' | curl -fsS --max-time 120 --keepalive-time 300 --compressed --tcp-fastopen --http2 -X POST https://openrouter.ai/api/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer $OPENROUTER_API_KEY" --data-binary @- | jq -r '.choices[0].message.content'
}
_convert_bash-backend-lowLatency() {
    #provider: { "order": ["SambaNova", "Fireworks", "Hyperbolic"]
    jq -Rs '{ model: "meta-llama/llama-3.1-405b-instruct", provider: { "order": ["Lambda", "Fireworks"], "sort": "latency" }, messages: [{"role": "user", "content": .}] }' | curl -fsS --max-time 120 --keepalive-time 300 --compressed --tcp-fastopen --http2 -X POST https://openrouter.ai/api/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer $OPENROUTER_API_KEY" --data-binary @- | jq -r '.choices[0].message.content'
}
_convert_bash-dispatch() {
    [[ "$1" == "" ]] && return 1
    [[ ! -e "$1" ]] && return 1
    echo 'quick brown fox' | _convert_bash-backend > /dev/null
    
    #-s 4096
    #-P $(nproc)
    find "$1" -maxdepth 1 -type f ! -iname '*.prompt.txt' ! -iname '*.response.txt' ! -iname '*.continue_prompt.txt' ! -iname '*.continue_response.txt' ! -iname '*.description.txt' -print0 | xargs -0 -x -L 1 -P 10 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _convert_bash_procedure "$@"' _
}


_semanticAssist_bash-backend() {
    #provider: { "order": ["SambaNova", "Fireworks", "Hyperbolic"]
    jq -Rs '{ model: "meta-llama/llama-3.1-405b-instruct", provider: { "order": ["Fireworks"], "sort": "throughput" },max_tokens: 15000, messages: [{"role": "user", "content": .}] }' | curl -fsS --max-time 120 --keepalive-time 300 --compressed --tcp-fastopen --http2 -X POST https://openrouter.ai/api/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer $OPENROUTER_API_KEY" --data-binary @- | jq -r '.choices[0].message.content'
}
_semanticAssist_bash-backend-lowLatency() {
    #provider: { "order": ["SambaNova", "Fireworks", "Hyperbolic"]
    jq -Rs '{ model: "meta-llama/llama-3.1-405b-instruct", provider: { "order": ["Lambda", "Fireworks"], "sort": "latency" },max_tokens: 500, messages: [{"role": "user", "content": .}] }' | curl -fsS --max-time 120 --keepalive-time 300 --compressed --tcp-fastopen --http2 -X POST https://openrouter.ai/api/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer $OPENROUTER_API_KEY" --data-binary @- | jq -r '.choices[0].message.content'
}
# ATTENTION: Override with 'ops.sh' or similar if appropriate.
# CAUTION: DANGER: Keywords generation is more prone to gibberish, special choice of AI LLM model may be required. See documentation for the '_here_semanticAssist-askGibberish' prompt.
_semanticAssist_bash-backend-lowLatency-special() {
    #_convert_bash-backend-lowLatency "$@"

    #provider: { "order": ["SambaNova", "Fireworks", "Hyperbolic"]
    jq -Rs '{ model: "meta-llama/llama-3.1-405b-instruct", provider: { "order": ["Lambda", "Fireworks"], "sort": "latency" },max_tokens: 500, messages: [{"role": "user", "content": .}] }' | curl -fsS --max-time 120 --keepalive-time 300 --compressed --tcp-fastopen --http2 -X POST https://openrouter.ai/api/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer $OPENROUTER_API_KEY" --data-binary @- | jq -r '.choices[0].message.content'

    ###provider: { "order": ["Lambda", "Fireworks"], "sort": "latency" }
    ##jq -Rs '{ model: "meta-llama/llama-4-scout", provider: { "sort": "latency" }, messages: [{"role": "user", "content": .}] }' | curl -fsS --max-time 120 --keepalive-time 300 --compressed --tcp-fastopen --http2 -X POST https://openrouter.ai/api/v1/chat/completions -H "Content-Type: application/json" -H "Authorization: Bearer $OPENROUTER_API_KEY" --data-binary @- | jq -r '.choices[0].message.content'
}
# ATTENTION: Override with 'ops.sh' or similar if appropriate.
# (ie. usually to change parallelization for high-latency APIs, providers, etc)
_semanticAssist_bash-dispatch() {
    [[ "$1" == "" ]] && return 1
    [[ ! -e "$1" ]] && return 1
    echo 'quick brown fox' | _semanticAssist_bash-backend > /dev/null
    
    #-s 4096
    #-P $(nproc)
    find "$1" -maxdepth 1 -type f -name '*.sh' -print0 | xargs -0 -x -L 1 -P 10 bash -c '"'"$scriptAbsoluteLocation"'"'' --embed _semanticAssist_bash_procedure "$@"' _
}

