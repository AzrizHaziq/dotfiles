
# ============================================================================
# Sesh Session Manager
# ============================================================================
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N            sesh-sessions
bindkey -M vicmd '^S' sesh-sessions
bindkey -M viins '^S' sesh-sessions

# ============================================================================
# Lazygit AI Commit Helper
# ============================================================================
lazygit-ai-commit() {
  set -e
  local DIFF_FILE=$(mktemp)
  trap "rm -f $DIFF_FILE" EXIT

  # Capture staged diff
  git diff --cached --no-ext-diff > "$DIFF_FILE"
  
  if [ ! -s "$DIFF_FILE" ]; then
    echo "❌ No staged changes to commit"
    return 1
  fi

  echo "🤖 Generating commit message..."
  
  # Multiline prompt for AI
  local PROMPT="You are a commit message generator using caveman-commit skill.
      Analyze the attached diff and generate a conventional commit message.
      desc must be in bullet points and after last points add new line.
      marker = >>>>>>>>>>>>>>>>>>>
      That's it. Start your response with the marker."

  # Call opencode
  local RAW=$(opencode run --agent build \
    --model github-copilot/claude-haiku-4.5 \
    --file "$DIFF_FILE" -- \
    "$PROMPT" 2>&1)
  
  # Extract commit message after marker
  # Keep blank lines for proper commit format (title + blank + body)
  local MSG=$(echo "$RAW" \
    | awk '/^>>>>>>>>>>>>>>>>>>>/{flag=1; next} flag' \
    | sed 's/\x1b\[[0-9;]*m//g' \
    | sed 's/^```.*$//; s/^```$//;')
  
  if [ -z "$MSG" ]; then
    echo "❌ AI generation failed. Opening manual commit..."
    git commit
    return $?
  fi

  echo "📝 Commit message:"
  echo "$MSG"
  echo ""
  
  # Commit with generated message
  echo "$MSG" | git commit -F -
  
  if [ $? -eq 0 ]; then
    echo "✅ Committed successfully"
  else
    echo "❌ Commit failed. Opening manual commit..."
    git commit
  fi
}
