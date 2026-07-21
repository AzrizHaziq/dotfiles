# AI-powered commit using opencode
function lazygit-ai-commit
    # Check for staged changes
    if test -z (git diff --cached --name-only)
        echo "No staged changes"
        return 1
    end

    opencode run --agent build --model github-copilot/claude-sonnet-4.5 \
        -- "Run git diff --cached, generate commit message with caveman-commit, then git commit. Prefer using bullet points and make new lines"
end
