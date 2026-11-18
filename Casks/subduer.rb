cask "subduer" do
  version "0.1.6"
  sha256 "d6a01c2955865f64e29adaf187f0144b8be76b514a6ee53ac1fa7ed41582ee06"

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
