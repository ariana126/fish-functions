function claude-code-openrouter
    env \
        ENABLE_TOOL_SEARCH=false \
        CLAUDE_CODE_SUBAGENT_MODEL="$OPENROUTER_MODEL" \
        ori claude --model "$OPENROUTER_MODEL" $argv
end
