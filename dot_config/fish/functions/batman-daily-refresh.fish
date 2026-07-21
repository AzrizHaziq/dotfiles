# Batman token daily refresh with 24h lockfile
function batman-daily-refresh
    set -l LOCKFILE "$HOME/.cache/batman-last-refresh"
    set -l NOW (date -u +%Y-%m-%dT%H:%M:%SZ)
    set -l NOW_EPOCH (date +%s)

    # Check if already ran in last 24 hours
    if test -f $LOCKFILE
        set -l LAST_RUN (cat $LOCKFILE)
        set -l LAST_RUN_EPOCH (date -d $LAST_RUN +%s 2>/dev/null; or echo 0)
        set -l ELAPSED (math $NOW_EPOCH - $LAST_RUN_EPOCH)

        if test $ELAPSED -lt 86400  # 24 hours
            set -l REMAINING (math 86400 - $ELAPSED)
            set -l HOURS (math -s0 $REMAINING / 3600)
            set -l MINS (math -s0 $REMAINING % 3600 / 60)
            echo "Last refreshed "(math -s0 $ELAPSED / 3600)"h "(math -s0 $ELAPSED % 3600 / 60)"m ago. Next in "$HOURS"h "$MINS"m."
            return 0
        end
    end

    # Run the refresh
    batman-refresh

    # Mark as completed
    echo $NOW >$LOCKFILE
end

# Batman refresh helper
function batman-refresh
    cd ~/work/enterprise-ai-forge-client/golang-client
    and go run ./cmd/llmclient login vscode
    and set -gx BATMAN_KEY (jq -r '.access_token' ~/.local/share/opencode/access-token.json)
    and echo "Batman env refreshed"
end
