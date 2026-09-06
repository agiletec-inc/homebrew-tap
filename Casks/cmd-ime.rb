cask "cmd-ime" do
  version "2.5.1"
  sha256 "0246dad8ae1bfa3186d36644c818512e5a95ac68a3d9e8aa641a28b4bcea23d5"

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

  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-cr", "{{appdir}}/CmdIME.app"],
        sudo: false
    # Refresh LaunchServices so the new bundle's icon and display
    # name are picked up immediately (otherwise Finder / System
    # Settings can show a stale entry).
    run "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
        args: ["-f", "{{appdir}}/CmdIME.app"],
        sudo: false
    # Auto-launch the new build so the user doesn't have to fish
    # for it after every upgrade.
    run "/usr/bin/open",
        args: ["{{appdir}}/CmdIME.app"],
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
