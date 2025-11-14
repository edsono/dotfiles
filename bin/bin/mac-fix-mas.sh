#!/usr/bin/env sh
#/ Usage: mas-fix
#/ Fix duplicate or old items on "Open With..." list in OSX
set -e

if [ "$1" = "--help" ]; then
	grep '^#/' <"$0" |
		cut -c4-
	exit 2
fi

defaults write com.apple.appstore ShowDebugMenu -boot true
killall AppStore

rm ~/Library/Preferences/com.apple.appstore.plist
rm ~/Library/Preferences/com.apple.storeagent.plist
rm ~/Library/Cookies/com.apple.appstore.plist

rm -r ~/Library/Caches/com.apple.appstore
rm -r ~/Library/Caches/com.apple.storeagent

echo "Relaunch Finder (control+option+click on Finder icon in the Dock)..."
