cask "scuttle" do
  version "0.1.6"
  sha256 "da237fa150bdcd6ea9b172b2ec0e8037478d2760fa7ddd65c5ea45a76b82eb64"

  url "https://github.com/cjcooper/scuttle/releases/download/v#{version}/Scuttle_#{version}_aarch64.dmg"
  name "Scuttle"
  desc "Menu bar controller for Colima, Docker and similar container runtimes"
  homepage "https://github.com/cjcooper/scuttle"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "Scuttle.app"

  uninstall launchctl: "Scuttle",
            quit:      "com.it-problems.scuttle",
            delete:    "~/Library/LaunchAgents/Scuttle.plist"

  zap trash: [
    "~/Library/Application Support/com.it-problems.scuttle",
    "~/Library/Caches/com.it-problems.scuttle",
    "~/Library/Preferences/com.it-problems.scuttle.plist",
    "~/Library/Saved Application State/com.it-problems.scuttle.savedState",
    "~/Library/WebKit/com.it-problems.scuttle",
  ]

  caveats <<~EOS
    Scuttle drives the docker CLI and needs a container runtime. For example:
      brew install colima docker
  EOS
end
