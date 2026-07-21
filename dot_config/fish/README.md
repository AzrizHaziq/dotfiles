# Fish Shell Config

## Structure

```
~/.config/fish/
├── config.fish          # Vim mode, minimal
├── conf.d/              # Auto-sourced alphabetically
│   ├── 00-path.fish     # PATH (loads first)
│   ├── 10-env.fish      # EDITOR, FZF opts
│   ├── 20-abbr.fish     # All abbreviations
│   ├── 30-tools.fish    # mise, zoxide
│   ├── 50-platform.fish # OS-specific (linux/mac/wsl)
│   ├── 99-local.fish    # Machine-specific (batman)
│   └── private_secrets.fish
├── functions/           # Autoloaded functions
│   ├── lazygit-ai-commit.fish
│   └── batman-daily-refresh.fish
└── fish_plugins         # Fisher
```

## Setup

```fish
# Install Fisher (plugin manager)
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

## Keybindings

### Vim Mode Indicators

- `[N]` = Normal mode (red)
- `[I]` = Insert mode (green)
- `[R]` = Replace mode (yellow)
- `[V]` = Visual mode (magenta)

### Vim Mode

| Key | Mode | Action |
|-----|------|--------|
| `Esc` | any | Normal mode |
| `i` | normal | Insert before cursor |
| `a` | normal | Insert after cursor |
| `A` | normal | Insert end of line |
| `I` | normal | Insert start of line |
| `h/l` | normal | Left/right |
| `j/k` | normal | Down/up (history) |
| `w/b` | normal | Word forward/back |
| `e` | normal | Word end |
| `0/$` | normal | Line start/end |
| `dd` | normal | Delete line |
| `cc` | normal | Change line |
| `yy` | normal | Yank line |
| `p` | normal | Paste |
| `u` | normal | Undo |
| `/` | normal | Search history |

### Fish Built-in

| Key | Action |
|-----|--------|
| `Tab` | Complete |
| `Tab Tab` | Show all completions |
| `Alt+Left/Right` | Jump word |
| `Alt+Up` | cd to parent dir |
| `Alt+Down` | cd into directory |
| `Alt+e` | Edit cmd in $EDITOR |
| `Alt+p` | Pipe to pager |
| `Alt+l` | List directory |
| `Alt+w` | Short help for cmd |
| `Ctrl+z` | Send to background |

## Abbreviations

Abbreviations expand inline. Type abbr, press Space.

```fish
# View all
abbr

# Add new
abbr -a NAME "COMMAND"

# Remove
abbr -e NAME
```

### Quick Reference

| Abbr | Expands to |
|------|------------|
| `gs` | `git status` |
| `gaa` | `git add --all` |
| `gc` | `git commit --verbose` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `glo` | `git log --oneline` |
| `grb` | `git rebase` |
| `grbi` | `git rebase --interactive` |
| `gsta` | `git stash push` |
| `gstp` | `git stash pop` |
| `gpf` | `git push --force-with-lease` |
| `gpsup` | `git push --set-upstream origin (branch)` |
| `ll` | `eza -l --icons --git` |
| `lt` | `eza tree` |
| `v` | `nvim` |
| `lz` | `lazygit` |
| `cz` | `chezmoi` |
| `cd` | `z` (zoxide) |

## Functions

```fish
# AI commit message
lazygit-ai-commit

# Batman token refresh (24h cooldown)
batman-daily-refresh
```

## Tips

```fish
# Reload config
source ~/.config/fish/config.fish

# See function source
functions FUNCNAME

# Where is command?
type -a COMMAND

# Edit function
funced FUNCNAME
funcsave FUNCNAME

# List all abbreviations
abbr --show
```

## Why Numbers in conf.d?

Fish sources `conf.d/*.fish` **alphabetically**.

- `00-*` loads first (PATH must exist before tools)
- `10-*` env vars
- `20-*` abbreviations
- `30-*` tools (need PATH)
- `50-*` platform (can override earlier)
- `99-*` local (final overrides)

Without numbers: `abbr.fish` < `path.fish` = broken.
