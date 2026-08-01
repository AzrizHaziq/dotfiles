# AI-powered commit using opencode
function ai-commit
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Not a git repository"
        return 1
    end

    # Check for staged changes
    if git diff --cached --quiet
        echo "No staged changes"
        return 1
    end

    set -l DIFF_FILE (mktemp)
    git diff --cached >$DIFF_FILE

    opencode run --agent build --model github-copilot/claude-sonnet-4.5 \
        --file $DIFF_FILE \
        -- "Generate commit message with caveman-commit, then git commit. Use bullet points. Do it now."

    set -l exit_code $status
    rm -f $DIFF_FILE
    return $exit_code
end
