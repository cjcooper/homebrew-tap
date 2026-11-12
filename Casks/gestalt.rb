cask "gestalt" do
  version "0.1.6"
  sha256 "049d684c717b4d9b424cd4d7a0bb4df3ede1957a051416b52e816cf936e80dcf"

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
