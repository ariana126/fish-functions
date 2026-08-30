function check-claude-safety
    set -l expected $SAFE_CLAUDE_IP
    set -l actual (curl -s --max-time 10 https://ifconfig.me)

    if test "$actual" = "$expected"
        return 0
    else
        echo "check-claude-safety: expected IP $expected, got '$actual'" >&2
        return 1
    end
end
