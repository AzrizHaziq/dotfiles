# Abbreviations - expand inline, visible in history
# abbr -a = add, persists across sessions

if status is-interactive
    abbr -a pn pnpm
    abbr -a y yarn
    abbr -a wdd "cd /mnt/c/Repos"
    abbr -a wd "cd ~/work"
    abbr -a cat bat
    abbr -a ls "eza --icons=always --color=always --group-directories-first"
    abbr -a ll "eza -l --header --icons=always --git --group-directories-first"
    abbr -a lt "eza -l --header --icons=always --git --group-directories-first --tree --level=2"
    abbr -a grep "grep --color=auto -n"
    abbr -a v nvim
    abbr -a vim nvim

    abbr -a c clear
    abbr -a reload "source ~/.config/fish/config.fish"
    abbr -a s "du -hs * | sort -rh | head -5"
    abbr -a gip "curl -s ipinfo.io/ip && echo && curl -s ipinfo.io/org"
    abbr -a f "find . -name"

    abbr -a cz chezmoi
    abbr -a ts tailscale
    abbr -a lz lazygit
    abbr -a ld lazydocker
    abbr -a lj lazyjournal
    abbr -a op opencode
    abbr -a tmux "tmux -f '$HOME/.config/tmux/tmux.conf'"

    abbr -a g git
    abbr -a ga "git add"
    abbr -a gaa "git add --all"
    abbr -a gb "git branch"
    abbr -a gba "git branch --all"
    abbr -a gbd "git branch --delete"
    abbr -a gbD "git branch --delete --force"
    abbr -a gco "git checkout"
    abbr -a gcb "git checkout -b"
    abbr -a gsw "git switch"
    abbr -a gswc "git switch --create"
    abbr -a gc "git commit --verbose"

    abbr -a gd "git diff"
    abbr -a gds "git diff --staged"
    abbr -a gdca "git diff --cached"
    abbr -a gdw "git diff --word-diff"
    abbr -a gf "git fetch"
    abbr -a gl "git pull"
    abbr -a gpr "git pull --rebase"
    abbr -a gp "git push"
    abbr -a gpf "git push --force-with-lease --force-if-includes"
    abbr -a gpf! "git push --force"
    abbr -a grs "git restore"
    abbr -a gsta "git stash push"

    abbr -a gs "git status"
    abbr -a gss "git status --short"
    abbr -a gsb "git status --short --branch"

    abbr -a gcp "git cherry-pick"
end
