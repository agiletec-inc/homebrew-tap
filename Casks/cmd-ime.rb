cask "cmd-ime" do
  version "2.4.11"
  sha256 "00c7b7ada1c794c6525c1f5fdc4ff06e613320f640b29832c490e9d9ddf36313"

  # The app updates itself via Sparkle; tell brew so it does not
  # treat a Sparkle-updated bundle as outdated and reinstall over it.
  auto_updates true

  url "https://github.com/agiletec-inc/cmd-ime/releases/download/v#{version}/cmd-ime-#{version}.dmg"
  name "⌘IME"
  desc "Command IME - Switch between alphanumeric and kana using Command keys"
  homepage "https://github.com/agiletec-inc/cmd-ime"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "CmdIME.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/CmdIME.app"],
                   sudo: false
    # Refresh LaunchServices so the new bundle's icon and display
    # name are picked up immediately (otherwise Finder / System
    # Settings can show a stale entry).
    lsregister = "/System/Library/Frameworks/CoreServices.framework/" \
                 "Frameworks/LaunchServices.framework/Support/lsregister"
    system_command lsregister,
                   args: ["-f", "#{appdir}/CmdIME.app"],
                   sudo: false
    # Auto-launch the new build so the user doesn't have to fish
    # for it after every upgrade.
    system_command "/usr/bin/open",
                   args: ["#{appdir}/CmdIME.app"],
                   sudo: false
  end

  # Gracefully quit the running menu bar agent before brew replaces
  # the .app, then SIGTERM/SIGKILL as fallback. AppleScript "quit"
  # alone is unreliable for an LSUIElement app under load, so the
  # signal stanza catches the process even if AE delivery fails.
  uninstall quit:   "com.kazuki.cmdime",
            signal: [
              ["TERM", "com.kazuki.cmdime"],
              ["KILL", "com.kazuki.cmdime"],
            ]

  zap trash: [
    "~/Library/Application Support/cmd-ime",
    "~/Library/Preferences/com.kazuki.cmdime.plist",
  ]
end
