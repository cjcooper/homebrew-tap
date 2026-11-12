cask "scuttle" do
  version "0.1.7"
  sha256 "1770a50857c12ffde5d84814715f90ad31a782b0bf2f09d289124db0f969ea14"

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
