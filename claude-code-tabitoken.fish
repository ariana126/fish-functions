function claude-code-tabitoken
    env \
        ANTHROPIC_API_KEY="" \
        ANTHROPIC_AUTH_TOKEN="$TABITOKEN_API_KEY"\
        ANTHROPIC_BASE_URL="https://tabitoken.com" \
        ANTHROPIC_MODEL="claude-opus-4-8-thinking" \
        claude --model "claude-opus-4-8-thinking" $argv
end
