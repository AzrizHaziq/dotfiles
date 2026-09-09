#!/usr/bin/env bash
# Outputs active workspace index for waybar custom module

workspaces=$(niri msg -j workspaces 2>/dev/null)
if [ -z "$workspaces" ]; then
  echo '{"text":"?","tooltip":"No niri"}'
  exit 0
fi

echo "$workspaces" | python3 -c "
import json, sys
ws = json.load(sys.stdin)
active = next((w['idx'] for w in ws if w.get('is_focused')), '?')
all_ws = ' '.join(str(w['idx']) for w in ws)
print(json.dumps({'text': str(active), 'tooltip': 'Workspaces: ' + all_ws}))
"
