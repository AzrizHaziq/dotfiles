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

    opencode run '/commit'

    return $status
end
