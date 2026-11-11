#!/bin/bash
# Writes Casks/otty.rb for one otty release.
#
# Usage: scripts/write-cask.sh <version> <aarch64 dmg sha256> <x86_64 dmg sha256>
#
# The download URL follows the DMG names made by scripts/macos/package.sh
# in the otty repository: otty-<version>-<arch>-apple-darwin.dmg.

set -euo pipefail

VERSION="${1:?version is required}"
ARM_SHA256="${2:?aarch64 sha256 is required}"
INTEL_SHA256="${3:?x86_64 sha256 is required}"

if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Version '$VERSION' is not MAJOR.MINOR.PATCH" >&2
  exit 1
fi

for sha in "$ARM_SHA256" "$INTEL_SHA256"; do
  if [[ ! "$sha" =~ ^[0-9a-f]{64}$ ]]; then
    echo "'$sha' is not a sha256 hex string" >&2
    exit 1
  fi
done

CASK_PATH="$(cd "$(dirname "$0")/.." && pwd)/Casks/otty.rb"

cat > "$CASK_PATH" <<EOF
cask "otty" do
  arch arm: "aarch64", intel: "x86_64"

  version "${VERSION}"
  sha256 arm:   "${ARM_SHA256}",
         intel: "${INTEL_SHA256}"

  url "https://github.com/otty-shell/otty/releases/download/v#{version}/otty-#{version}-#{arch}-apple-darwin.dmg"
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

    It does this again after every \`brew upgrade --cask otty\`.
  EOS
end
EOF

echo "Wrote $CASK_PATH for otty $VERSION"
