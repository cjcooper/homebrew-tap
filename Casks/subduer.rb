cask "subduer" do
  version "0.1.7"
  sha256 "eb6e1d9bbd4706780b18ff8cbe189e5d20f6e97368daa9aa9e01a5f41b39c917"

  url "https://github.com/cjcooper/subduer/releases/download/v#{version}/Subduer_#{version}_aarch64.dmg"
  name "Subduer"
  desc "Desktop app for browsing and controlling Kubernetes clusters"
  homepage "https://github.com/cjcooper/subduer"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "Subduer.app"

  uninstall quit: "com.it-problems.k8s-subduer"

  zap trash: [
    "~/Library/Application Support/com.it-problems.k8s-subduer",
    "~/Library/Caches/com.it-problems.k8s-subduer",
    "~/Library/Preferences/com.it-problems.k8s-subduer.plist",
    "~/Library/Saved Application State/com.it-problems.k8s-subduer.savedState",
    "~/Library/WebKit/com.it-problems.k8s-subduer",
  ]
end
