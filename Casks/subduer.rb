cask "subduer" do
  version "0.1.5"
  sha256 "00ca04c715e2c1f2cae1baa56e82438ff62a2d852980918ebca79808e2699726"

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
