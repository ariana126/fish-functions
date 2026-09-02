function claude-code
    set -l provider (gum choose \
        --header "Model provider" \
        "Anthropic" \
        "Openrouter" \
        "kktoken" \
        "tabitoken" \
        "gorouter" \
        "justwoker")

    switch $provider
        case Anthropic
            claude $argv
        case Openrouter
            claude-code-openrouter $argv
        case kktoken
            claude-code-kktoken $argv
        case tabitoken
            claude-code-tabitoken $argv
        case gorouter
            claude-code-gorouter $argv
        case justwoker
            claude-code-justwoker $argv
    end
end
