cask "cmd-ime" do
  version "1.3.7"
  sha256 "98b15908dbd3aa3d28ea74768f03c966308fbdd5d045e0ed667c9556912d7fab"

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
