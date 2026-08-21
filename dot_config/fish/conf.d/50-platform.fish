# Platform-specific config

# if status is-interactive
# 
#     switch (uname)
#         case Linux
#             # Check if WSL
#             if test -f /proc/version; and grep -qi microsoft /proc/version
#                 # ═══════════════════════════════════════════════════════════════
#                 # WSL (Windows Subsystem for Linux)
#                 # ═══════════════════════════════════════════════════════════════
#                 abbr -a repos "cd /mnt/c/Repos"
#                 abbr -a pbcopy clip.exe
#                 abbr -a pbpaste "powershell.exe -command Get-Clipboard"
#             else
#                 # ═══════════════════════════════════════════════════════════════
#                 # Native Linux
#                 # ═══════════════════════════════════════════════════════════════
#                 abbr -a open xdg-open
#                 abbr -a pbcopy "xclip -selection clipboard"
#                 abbr -a pbpaste "xclip -selection clipboard -o"
#             end
# 
#         case Darwin
#             # ═══════════════════════════════════════════════════════════════════
#             # macOS
#             # ═══════════════════════════════════════════════════════════════════
#             fish_add_path -gP /opt/homebrew/bin
# 
#             # pnpm
#             set -gx PNPM_HOME "$HOME/Library/pnpm"
#             fish_add_path -gP $PNPM_HOME
#     end
# end
