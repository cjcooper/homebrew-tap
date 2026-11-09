cask "gestalt" do
  version "0.1.5"
  sha256 "36ba54884ed7f4837f0767d2857f368e163804d71ef9b911564a637b982229c1"

  url "https://github.com/cjcooper/gestalt/releases/download/v#{version}/Gestalt_#{version}_aarch64.dmg"
  name "Gestalt"
  desc "Desktop runner for OpenTofu across a folder tree"
  homepage "https://github.com/cjcooper/gestalt"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "Gestalt.app"

  uninstall quit: "com.it-problems.gestalt"

  zap trash: [
    "~/Library/Application Support/com.it-problems.gestalt",
    "~/Library/Caches/com.it-problems.gestalt",
    "~/Library/Preferences/com.it-problems.gestalt.plist",
    "~/Library/Saved Application State/com.it-problems.gestalt.savedState",
    "~/Library/WebKit/com.it-problems.gestalt",
  ]

  caveats <<~EOS
    Gestalt runs the tofu CLI. For example:
      brew install opentofu
  EOS
end
