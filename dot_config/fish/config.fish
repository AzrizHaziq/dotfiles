# Fish config - minimal, fast
# conf.d/*.fish auto-sourced alphabetically

if status is-interactive
    fish_vi_key_bindings

    # Cursor shape for vim modes
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_visual block

    # Mode indicator in prompt
    function fish_mode_prompt
        switch $fish_bind_mode
            case default
                echo '📘 '
            case insert
                echo '✨ '
            case replace_one
                echo '🟡 '
            case visual
                echo '🚧 '
        end
    end

    # Custom keybindings (insert mode)
    bind -M insert \cy accept-autosuggestion   # Ctrl+Y: accept suggestion
    bind -M insert \cp up-or-search            # Ctrl+P: previous history
    bind -M insert \cn down-or-search          # Ctrl+N: next history

    # Configure fzf.fish bindings AFTER vi keybindings to prevent override
    fzf_configure_bindings
end
