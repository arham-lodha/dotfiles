#!/bin/bash
sleep 0.1

BOUNDS=$(osascript -e 'tell application "Finder" to get bounds of window of desktop')
LEFT=$(echo "$BOUNDS"  | awk -F',' '{print $1+0}')
TOP=$(echo "$BOUNDS"   | awk -F',' '{print $2+0}')
RIGHT=$(echo "$BOUNDS" | awk -F',' '{print $3+0}')
BOTTOM=$(echo "$BOUNDS"| awk -F',' '{print $4+0}')

MENU_BAR=25
WIDTH=$((RIGHT - LEFT))
HEIGHT=$((BOTTOM - TOP - MENU_BAR))
WIN_TOP=$((TOP + MENU_BAR))

osascript << EOF
tell application "System Events"
    set frontApp to first application process whose frontmost is true
    set position of first window of frontApp to {$LEFT, $WIN_TOP}
    set size of first window of frontApp to {$WIDTH, $HEIGHT}
end tell
EOF
