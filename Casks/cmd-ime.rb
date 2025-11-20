cask "cmd-ime" do
  version "0.1.0"
  sha256 "5b1ef1812089a3f4f44c8149dfea2298f78c36375ffffc65b2144484253fdc0c"

  url "https://github.com/agiletec-inc/cmd-ime/releases/download/v#{version}/cmd-ime-#{version}.dmg"
  name "⌘IME"
  desc "Command IME - Switch between alphanumeric and kana using Command keys"
  homepage "https://github.com/agiletec-inc/cmd-ime"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "CmdIME.app"

  zap trash: [
    "~/Library/Preferences/com.kazuki.cmd-ime.plist",
    "~/Library/Application Support/cmd-ime",
  ]
end
