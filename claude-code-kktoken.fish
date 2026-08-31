function claude-code-kktoken
    env \
        ANTHROPIC_API_KEY="" \
        ANTHROPIC_AUTH_TOKEN="$KKTOKEN_API_KEY" \
        ANTHROPIC_BASE_URL="https://kktoken.cc" \
        ANTHROPIC_MODEL="claude-opus-5-thinking" \
        claude --model "claude-opus-5-thinking" $argv
end
