# Tool integrations - mise, zoxide

if status is-interactive
    if command -q mise
        mise activate fish | source
    end

    if command -q zoxide
        zoxide init fish | source
    end

    if command -q pnpm
        pnpm completion fish | source
    end

    if command -q workmux
        workmux completions fish | source
    end
end
