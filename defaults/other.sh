#!/usr/bin/env bash

# Chrome
open -a "Google Chrome"
read -p "ℹ️  Setup Chrome and close application..."
./defaults/other/chrome.sh

# Remove the Shift-Command-A hot key
defaults write com.TickTick.task.mac TKQuickAddTaskHotkeyIdentifier -data ""

# Remove the Shift-Command-O hot key
defaults write com.TickTick.task.mac TKShowOrHideAppHotkeyIdentifier -data ""

# Hide Smart Lists
read -r -d '' XML <<'EOF'
<dict>
  <key>5fc03fcf9b4251d53f94d30e</key>
  <dict>
    <key>Smart_CALENDAR_PROJECT_ID</key>
    <integer>1</integer>
    <key>Smart_NEXT7DAYS_PROJECT_ID</key>
    <integer>1</integer>
    <key>Smart_TODAY_PROJECT_ID</key>
    <integer>1</integer>
    <key>Smart_TOMORROW_PROJECT_ID</key>
    <integer>1</integer>
  </dict>
</dict>
EOF

# Calendar
defaults write com.apple.iCal "display birthdays calendar" 0
