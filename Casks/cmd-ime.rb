cask "cmd-ime" do
  version "1.2.1"
  sha256 "fb3aafc8a39bcbaa086fef6e7043ba2015f08ff7ded1b44a454ea0b70131df46"

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
