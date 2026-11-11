cask "otty" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.1.0"
  sha256 arm:   "c1e47f7aec6fb1b94b621db49a3cf26ac18a2441de42391e299627358d67b9c7",
         intel: "e83d46de9bfe9f97b36497e351044730ded4106314dae98ee65cda70ddabeef6"

  url "https://github.com/otty-shell/otty/releases/download/v#{version}/otty_#{version}-#{arch}-apple-darwin.dmg"
  name "otty"
  desc "Terminal emulator"
  homepage "https://github.com/otty-shell/otty"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "otty.app"

  zap trash: "~/.config/otty"

  caveats <<~EOS
    otty is not notarized by Apple, so macOS blocks its first launch.
    To allow it, do one of these:
      1. Open otty, then go to System Settings → Privacy & Security
         and click "Open Anyway".
      2. Run: xattr -dr com.apple.quarantine "#{appdir}/otty.app"
  EOS
end
