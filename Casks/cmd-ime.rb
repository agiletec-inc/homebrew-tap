cask "cmd-ime" do
  version "1.2.6"
  sha256 "0c1ac149476395a8ba39af4f84716a09c4a6b519ea194126649a7587269d36ef"

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
