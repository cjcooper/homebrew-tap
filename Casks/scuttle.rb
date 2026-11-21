cask "scuttle" do
  version "0.1.8"
  sha256 "b9cfc83730b019816fcdbf600a227a3577c0dc70c022d334a02d508667bed01f"

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
            quit:      "com.it-problems.scuttle"

  zap trash: [
    "~/Library/Application Support/com.it-problems.scuttle",
    "~/Library/Caches/com.it-problems.scuttle",
    "~/Library/LaunchAgents/Scuttle.plist",
    "~/Library/Preferences/com.it-problems.scuttle.plist",
    "~/Library/Saved Application State/com.it-problems.scuttle.savedState",
    "~/Library/WebKit/com.it-problems.scuttle",
  ]

  caveats <<~EOS
    Scuttle drives the docker CLI and needs a container runtime. For example:
      brew install colima docker
  EOS
end
