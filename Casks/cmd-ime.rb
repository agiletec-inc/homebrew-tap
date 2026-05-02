cask "cmd-ime" do
  version "1.3.2"
  sha256 "7c4c0736f14407c3efc1190ac586786c34dd70f0b9da472a2c5dde20160c5e1a"

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
  end

  zap trash: [
    "~/Library/Preferences/com.kazuki.cmd-ime.plist",
    "~/Library/Application Support/cmd-ime",
  ]
end
