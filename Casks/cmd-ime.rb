cask "cmd-ime" do
  version "1.1.2"
  sha256 "6eba61c314c477e62f34f330be151f39a51826ebf930e2ae6f1a43f569ce7ae3"

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
