#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# DEPS & CONFIG — everything this script needs, up front.
# ============================================================================

# Folder this script lives in (default.kitty-session + kitty-sessionizer.conf
# live right next to it).
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

SESSION_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/kitty/sessions"
DEFAULT_SESSION="$SCRIPT_DIR/default.kitty-session"

# kitty launches this script with a bare PATH (no mise/local bin), so
# fzf/fd/jq/kitten below would not be found without this.
export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

# fzf's colors/layout live in fish config (FZF_DEFAULT_OPTS), but kitty
# doesn't source shell rc files — pull it from fish directly so the picker
# actually looks like the rest of your fzf usage.
if [[ -z "${FZF_DEFAULT_OPTS:-}" ]] && command -v fish >/dev/null 2>&1; then
    FZF_DEFAULT_OPTS="$(fish -c 'echo $FZF_DEFAULT_OPTS' 2>/dev/null)"
    export FZF_DEFAULT_OPTS
fi

# Defaults, overridable via kitty-sessionizer.conf.
KS_SEARCH_PATHS=()   # e.g. (/home/user/work:5 /home/user/.config)
KS_MAX_DEPTH=1
ZOXIDE_LIMIT=15      # how many extra zoxide entries to tack on at the end
# shellcheck disable=SC1091
source "$SCRIPT_DIR/kitty-sessionizer.conf" 2>/dev/null || true

# Required: nothing works without these. Optional: features degrade quietly.
REQUIRED_BINS=(fzf kitten)
OPTIONAL_BINS=(jq fd zoxide)

missing_required=()
for b in "${REQUIRED_BINS[@]}"; do
    command -v "$b" >/dev/null 2>&1 || missing_required+=("$b")
done

missing_optional=()
for b in "${OPTIONAL_BINS[@]}"; do
    command -v "$b" >/dev/null 2>&1 || missing_optional+=("$b")
done

# If a required dep is missing, DON'T let the panel just vanish — say why
# and wait, so the error is actually readable.
if [[ ${#missing_required[@]} -gt 0 ]]; then
    echo "kitty-list-sessions: missing required command(s): ${missing_required[*]}"
    echo "PATH=$PATH"
    read -rp "press enter to close..." _
    exit 1
fi
if [[ ${#missing_optional[@]} -gt 0 ]]; then
    echo "kitty-list-sessions: optional command(s) missing (some features disabled): ${missing_optional[*]}"
fi

# ============================================================================
# MAIN
# ============================================================================

mkdir -p "$SESSION_DIR"

# When launched from the floating quick-access window, this runs in a
# separate kitty instance. KITTY_MAIN_SOCKET (set by kitty-session-float.sh)
# redirects remote-control calls to the main instance instead of ourselves.
KITTEN_TO=()
[[ -n "${KITTY_MAIN_SOCKET:-}" ]] && KITTEN_TO=(--to "$KITTY_MAIN_SOCKET")
KITTEN_TO_STR="${KITTEN_TO[*]:-}"

find_repos() {
    local entry path depth
    for entry in "${KS_SEARCH_PATHS[@]}"; do
        path="${entry%%:*}"
        depth="${entry##*:}"
        [[ "$path" == "$entry" ]] && depth="$KS_MAX_DEPTH"
        # Anchored to the exact name ".git". An unanchored pattern also
        # matches ".github" (and similar), duplicating every repo that has one.
        [[ -d "$path" ]] && fd --hidden -t d -d "$depth" '^\.git$' "$path" --format '{//}'
    done
}

# Active sessions: tab title prefixes from `kitten @ ls`, intersected with
# on-disk session files so stray titles never show as active. Current
# session is whatever --match=session:. resolves to from inside this overlay.
declare -A active=()
current_name=""
if command -v jq >/dev/null 2>&1; then
    while IFS= read -r name; do
        [[ -z "$name" ]] && continue
        [[ -f "$SESSION_DIR/$name.kitty-session" ]] && active["$name"]=1
    done < <(
        kitten @ "${KITTEN_TO[@]}" ls 2>/dev/null \
          | jq -r '[.[].tabs[].title] | .[] | sub(" - .*$"; "")' 2>/dev/null \
          | sort -u
    )
    if [[ ${#KITTEN_TO[@]} -gt 0 ]]; then
        # Remote (floating window): session:. is meaningless here, so use the
        # focused OS window's first tab title instead (same convention).
        current_name=$(
            kitten @ "${KITTEN_TO[@]}" ls 2>/dev/null \
              | jq -r 'map(select(.is_focused))[0].tabs[0].title // empty' 2>/dev/null \
              | sed 's/ - .*//'
        )
    else
        current_name=$(
            kitten @ ls --match=session:. 2>/dev/null \
              | jq -r '.[0].tabs[0].title // empty' 2>/dev/null \
              | sed 's/ - .*//'
        )
    fi
fi

TSV=$(mktemp -t kitty-sessions.XXXXXX.tsv)
DEL_HELPER=$(mktemp -t kitty-del.XXXXXX.sh)
RELOAD_HELPER=$(mktemp -t kitty-reload.XXXXXX.sh)
trap 'rm -f "$TSV" "$DEL_HELPER" "$RELOAD_HELPER"' EXIT

# ctrl-d: close the session if it's running, then drop the saved file.
cat > "$DEL_HELPER" <<EOF
#!/usr/bin/env bash
sdir='$SESSION_DIR'
f="\$1"
name="\$(basename "\$f" .kitty-session)"
kitten @ $KITTEN_TO_STR action close_session --match=session:"\$name" >/dev/null 2>&1 || true
if [[ -f "\$f" && "\$f" == "\$sdir"/*.kitty-session ]]; then
    rm -f -- "\$f"
fi
EOF
cat > "$RELOAD_HELPER" <<EOF
#!/usr/bin/env bash
awk -F'\t' -v p="\$1" '\$2 != p' '$TSV'
EOF
chmod +x "$DEL_HELPER" "$RELOAD_HELPER"

# Build TSV: display_name<TAB>session_path<TAB>repo_path(optional)
# Order: current -> other active -> known-but-closed -> new repos -> zoxide.
# Icons:  current, active, closed (blank), new repo, zoxide
# seen_names/seen_paths dedupe the zoxide tail against everything above it.
declare -A seen_names=()
declare -A seen_paths=()
{
    if [[ -n "$current_name" && -f "$SESSION_DIR/$current_name.kitty-session" ]]; then
        printf '★ %s\t%s\t\n' "$current_name" "$SESSION_DIR/$current_name.kitty-session"
        seen_names["$current_name"]=1
    fi
    for name in $(printf '%s\n' "${!active[@]}" | sort -f); do
        [[ "$name" == "$current_name" ]] && continue
        printf '▶ %s\t%s\t\n' "$name" "$SESSION_DIR/$name.kitty-session"
        seen_names["$name"]=1
    done
    if [[ -d "$SESSION_DIR" ]]; then
        while IFS= read -r session_path; do
            name="${session_path##*/}"
            name="${name%.kitty-session}"
            [[ -n "${active[$name]+_}" ]] && continue
            [[ "$name" == "$current_name" ]] && continue
            printf '  %s\t%s\t\n' "$name" "$session_path"
            seen_names["$name"]=1
        done < <(find "$SESSION_DIR" -maxdepth 1 -name '*.kitty-session' | sort -f)
    fi
    while IFS= read -r repo; do
        name="${repo##*/}"
        session_path="$SESSION_DIR/${name}.kitty-session"
        [[ -f "$session_path" ]] && continue
        printf '+ %s\t%s\t%s\n' "$name" "$session_path" "$repo"
        seen_names["$name"]=1
        seen_paths["$repo"]=1
    done < <(find_repos | sort -f)
    if command -v zoxide >/dev/null 2>&1; then
        count=0
        while IFS= read -r zpath; do
            [[ $count -ge $ZOXIDE_LIMIT ]] && break
            [[ -d "$zpath" ]] || continue
            [[ -n "${seen_paths[$zpath]+_}" ]] && continue
            name="${zpath##*/}"
            [[ -n "${seen_names[$name]+_}" ]] && continue
            session_path="$SESSION_DIR/${name}.kitty-session"
            [[ -f "$session_path" ]] && continue
            printf '~ %s\t%s\t%s\n' "$name" "$session_path" "$zpath"
            seen_names["$name"]=1
            count=$((count + 1))
        done < <(zoxide query -l 2>/dev/null)
    fi
} > "$TSV"

# Preview panel wasn't earning its keep (mostly empty/unreadable) — disabled.
# Re-enable by uncommenting PREVIEW plus the --preview/--preview-window flags.
# PREVIEW='f={2}; if [[ -f "$f" ]]; then bat --style=plain --color=always --paging=never -- "$f"; else echo "(new — generated from default template)"; fi'

selected=$(
    fzf \
        --prompt "Project > " \
        --delimiter $'\t' \
        --with-nth 1 \
        --header 'enter: switch · ctrl-e: edit · ctrl-d: close+delete' \
        --bind "ctrl-e:execute(\${EDITOR:-nvim} -- {2})" \
        --bind "ctrl-d:execute-silent($DEL_HELPER {2})+reload($RELOAD_HELPER {2})" \
        < "$TSV"
) || true

[[ -z "$selected" ]] && exit 0

session_file=$(printf '%s' "$selected" | cut -f2)
repo_path=$(printf '%s' "$selected" | cut -f3)


# Generate session from template if it does not exist
if [[ ! -f "$session_file" ]]; then
    name=$(basename "$session_file" .kitty-session)
    if [[ -n "$repo_path" ]]; then
        sed -e "s|@@session-path@@|$repo_path|g" -e "s|@@session@@|$name|g" \
            "$DEFAULT_SESSION" > "$session_file"
    fi
fi

# Persist the session we are leaving so it reopens in its last state, then
# close its tabs so switching feels like a swap instead of an accumulating
# pile of hidden tabs (tab_bar_filter only hides them, doesn't close them).
if [[ -n "$current_name" \
   && "$session_file" != "$SESSION_DIR/$current_name.kitty-session" ]]; then
    if [[ "$(kitten @ "${KITTEN_TO[@]}" ls --match=session:"$current_name" 2>/dev/null \
            | jq -r 'length' 2>/dev/null || echo 0)" -gt 0 ]]; then
        kitten @ "${KITTEN_TO[@]}" action save_as_session \
            --match=session:"$current_name" \
            --use-foreground-process \
            --relocatable \
            --save-only \
            "$SESSION_DIR/$current_name.kitty-session" 2>/dev/null || true

        kitten @ "${KITTEN_TO[@]}" close-tab \
            --match "session:$current_name" \
            --no-response --ignore-no-match 2>/dev/null || true
    fi
fi

kitten @ "${KITTEN_TO[@]}" action goto_session "$session_file"
