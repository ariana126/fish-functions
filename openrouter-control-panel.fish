function openrouter-control-panel
    set -l db ~/.openrouter-control-panel/database.json

    if not test -f $db
        gum style \
            --foreground 1 \
            --border rounded \
            --padding "0 1" \
            "Database not found: $db"
        return 1
    end

    if not type -q gum
        echo "gum is not installed."
        return 1
    end

    if not type -q jq
        gum style \
            --foreground 1 \
            --border rounded \
            --padding "0 1" \
            "jq is not installed."
        return 1
    end

    set -l accounts (jq -r '.accounts[] | [.email, .api_key] | @tsv' $db)
    set -l models (jq -r '.models[] | [.model, .context] | @tsv' $db)

    while true
        # Find selected account
        set -l selected_account "(not set)"

        for account in $accounts
            set -l parts (string split \t $account)

            if test "$parts[2]" = "$OPENROUTER_API_KEY"
                set selected_account $parts[1]
                break
            end
        end

        # Find selected model
        set -l selected_model "(not set)"

        for model in $models
            set -l parts (string split \t $model)

            if test "$parts[1]" = "$OPENROUTER_MODEL"
                set selected_model "$parts[1]  ·  $parts[2]"
                break
            end
        end

        # Main menu
        set -l choice (
            gum choose \
                --header "OpenRouter Control Panel" \
                "Account:  $selected_account" \
                "Model:    $selected_model"
        )

        if test $status -ne 0 -o -z "$choice"
            return 0
        end

        switch "$choice"
            case "Account:*"
                set -l account_choices

                for account in $accounts
                    set -l parts (string split \t $account)
                    set -a account_choices $parts[1]
                end

                set -l selected (
                    gum choose \
                        --header "Select Account" \
                        $account_choices
                )

                if test $status -ne 0 -o -z "$selected"
                    return 0
                end

                for account in $accounts
                    set -l parts (string split \t $account)

                    if test "$parts[1]" = "$selected"
                        set -Ux OPENROUTER_API_KEY $parts[2]
                        break
                    end
                end

            case "Model:*"
                set -l model_choices

                for model in $models
                    set -l parts (string split \t $model)
                    set -a model_choices "$parts[1]  ·  $parts[2]"
                end

                set -l selected (
                    gum choose \
                        --header "Select Model" \
                        $model_choices
                )

                if test $status -ne 0 -o -z "$selected"
                    return 0
                end

                set -l model_name (
                    string replace -r '  ·  .+$' '' -- "$selected"
                )

                set -Ux OPENROUTER_MODEL $model_name
        end
    end
end
