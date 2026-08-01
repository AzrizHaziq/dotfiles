# Tool integrations - mise, zoxide

if status is-interactive
    if command -q mise
        mise activate fish | source
    end

    if command -q zoxide
        zoxide init fish | source
        abbr -a cd z
    end

end
