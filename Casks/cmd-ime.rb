cask "cmd-ime" do
  version "1.3.6"
  sha256 "96eb3a0aeb7ee108b8b5a76e8ad381d80c84e1cb35d929d58c0012156836514d"

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
  # the .app, otherwise the old process keeps running on the freed
  # binary and macOS will not pick up the new build's Accessibility
  # entry until the user manually restarts.
  uninstall quit: "com.kazuki.cmdime"

  zap trash: [
    "~/Library/Application Support/cmd-ime",
    "~/Library/Preferences/com.kazuki.cmdime.plist",
  ]
end
