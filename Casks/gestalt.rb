cask "gestalt" do
  version "0.1.14"
  sha256 "1b251dffd400418f9de3ab4fe72c80e0ab7d01b096eab05fb727d3168fb7a70a"

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
