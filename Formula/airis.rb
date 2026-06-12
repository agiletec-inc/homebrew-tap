class Airis < Formula
  desc "AIRIS suite dispatcher: airis <tool> runs airis-<tool> from PATH"
  homepage "https://github.com/agiletec-inc/homebrew-tap"
  url "https://raw.githubusercontent.com/agiletec-inc/homebrew-tap/bdc5d1635feafb5cc2f397008ea6882c4a9cc920/bin/airis"
  sha256 "5edb860ab27720f1da96e049856b05e7f8211cb597a307e51998708ca6523d01"
  version "1.0.0"
  license "MIT"

  def install
    bin.install "airis"
  end

  test do
    assert_match "AIRIS suite dispatcher", shell_output("#{bin}/airis --help")
  end
end
