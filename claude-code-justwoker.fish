function claude-code-justwoker
    env \
        ANTHROPIC_API_KEY="" \
        ANTHROPIC_AUTH_TOKEN="$JUSTWOKER_API_KEY" \
        ANTHROPIC_BASE_URL="https://api.justwoker.icu" \
        ANTHROPIC_MODEL="claude-opus-5-thinking" \
        claude --model "claude-opus-5-thinking" $argv
end
