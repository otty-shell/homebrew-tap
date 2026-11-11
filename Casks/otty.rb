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

  # otty is not notarized by Apple. macOS reports such apps as "damaged"
  # while they carry the quarantine mark, so the mark is removed here.
  postflight do
    system_command "/usr/bin/xattr",
                   args:         ["-dr", "com.apple.quarantine", "#{appdir}/otty.app"],
                   print_stderr: false
  end

  zap trash: "~/.config/otty"

  caveats <<~EOS
    otty is not notarized by Apple. macOS marks every downloaded app with
    a "quarantine" flag, and for an app that is not notarized it then
    refuses to start it with the message "otty is damaged and can't be
    opened". The app is not damaged.

    So that otty opens normally, this cask has removed the flag:
      xattr -dr com.apple.quarantine "#{appdir}/otty.app"

    It does this again after every `brew upgrade --cask otty`.
  EOS
end
