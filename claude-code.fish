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
            claude
        case Openrouter
            claude-code-openrouter
        case kktoken
            claude-code-kktoken
        case tabitoken
            claude-code-tabitoken
        case gorouter
            claude-code-gorouter
        case justwoker
            claude-code-justwoker
    end
end