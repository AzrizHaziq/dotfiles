# AI-powered commit using opencode
function lazygit-ai-commit
    # Check for staged changes
    if not git diff --cached --quiet
        set -l DIFF_FILE (mktemp)
        git diff --cached >$DIFF_FILE

        opencode run --agent build --model github-copilot/claude-sonnet-4.5 \
            --file $DIFF_FILE \
            -- "Generate commit message with caveman-commit, then git commit. Use bullet points. Do it now."

        rm -f $DIFF_FILE
    else
        echo "No staged changes"
        return 1
    end
end
