cask "gestalt" do
  version "0.1.10"
  sha256 "7c1a99faa1486ba7ff40f835cbea63bae3c5db9abd9e5fd158e5e7a8b8b0aef0"

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
