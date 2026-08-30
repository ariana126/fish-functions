function openrouter-control-panel
    set -l database_file ~/.openrouter-control-panel/database.json

    if not test -f $database_file
        echo "Error: $database_file does not exist"
        return 1
    end

    if not command -q jq
        echo "Error: jq is required"
        return 1
    end

    set -l command $argv[1]

    # Show control panel
    if test (count $argv) -eq 0
        set -l active_key $OPENROUTER_API_KEY
        set -l active_model $OPENROUTER_MODEL

        echo
        echo "  OpenRouter Control Panel"
        echo "  ──────────────────────────────────────────────────────────────────────────────"
        echo

        echo "  Accounts"
        echo
        printf "    %-2s %-16s %s\n" "" "Alias" "Email"
        printf "    %-2s %-16s %s\n" "" "────────────────" "────────────────────────────────────"

        jq -r '.accounts[] | "\(.alias)\t\(.email)\t\(.api_key)"' $database_file |
        while read -l alias email api_key
            if test "$api_key" = "$active_key"
                printf "    %-2s %-16s %s\n" "*" $alias $email
            else
                printf "    %-2s %-16s %s\n" "" $alias $email
            end
        end

        echo
        echo "  Models"
        echo
        printf "    %-2s %-16s %-65s %s\n" "" "Alias" "Model" "Context"
        printf "    %-2s %-16s %-65s %s\n" "" "────────────────" "─────────────────────────────────────────────────────────────────" "───────"

        jq -r '.models[] | "\(.alias)\t\(.model)\t\(.context)"' $database_file |
        while read -l alias model context
            if test "$model" = "$active_model"
                printf "    %-2s %-16s %-65s %s\n" "*" $alias $model $context
            else
                printf "    %-2s %-16s %-65s %s\n" "" $alias $model $context
            end
        end

        echo
        echo "  Commands"
        echo
        echo "    set-account <alias>    Switch account"
        echo "    set-model <alias>      Switch model"
        echo

        return 0
    end

    # Set account
    if test "$command" = "set-account"
        if test (count $argv) -ne 2
            echo "Usage: openrouter-control-panel set-account <account-alias>"
            return 1
        end

        set -l alias $argv[2]

        set -l account (jq -r --arg alias "$alias" \
            '.accounts[] | select(.alias == $alias) | [.email, .api_key] | @tsv' \
            $database_file)

        if test -z "$account"
            echo "Error: account '$alias' not found"
            echo
            echo "Available accounts:"
            jq -r '.accounts[].alias' $database_file | sed 's/^/  /'
            return 1
        end

        set -l fields (string split \t $account)
        set -l email $fields[1]
        set -l api_key $fields[2]

        set -Ux OPENROUTER_API_KEY $api_key

        echo "Switched account:"
        echo "  Alias: $alias"
        echo "  Email: $email"

        return 0
    end

    # Set model
    if test "$command" = "set-model"
        if test (count $argv) -ne 2
            echo "Usage: openrouter-control-panel set-model <model-alias>"
            return 1
        end

        set -l alias $argv[2]

        set -l model (jq -r --arg alias "$alias" \
            '.models[] | select(.alias == $alias) | .model' \
            $database_file)

        if test -z "$model"
            echo "Error: model '$alias' not found"
            echo
            echo "Available models:"
            jq -r '.models[] | "\(.alias)\t\(.model)"' $database_file |
            while read -l model_alias model_id
                printf "  %-16s %s\n" $model_alias $model_id
            end
            return 1
        end

        set -Ux OPENROUTER_MODEL $model

        echo "Switched model:"
        echo "  Alias: $alias"
        echo "  Model: $model"

        return 0
    end

    echo "Usage:"
    echo "  openrouter-control-panel"
    echo "  openrouter-control-panel set-account <account-alias>"
    echo "  openrouter-control-panel set-model <model-alias>"

    return 1
end
