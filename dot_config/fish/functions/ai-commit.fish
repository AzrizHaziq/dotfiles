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

    opencode run --agent build --auto \
        --file $DIFF_FILE \
        -- "Use the caveman-commit skill. The attached file is the staged diff. Generate a Conventional Commits message: subject ≤50 chars, bullet-point body only when the why is not obvious. Then immediately run git commit with that message. Do not ask for confirmation."

    set -l exit_code $status
    rm -f $DIFF_FILE
    return $exit_code
end
