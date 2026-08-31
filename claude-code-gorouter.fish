function claude-code-gorouter
    env \
        ANTHROPIC_API_KEY="" \
        ANTHROPIC_AUTH_TOKEN="$GOROUTER_API_KEY" \
        ANTHROPIC_BASE_URL="https://gorouter.app" \
        ANTHROPIC_MODEL="claude-opus-5" \
        claude --model "claude-opus-5" $argv
end
