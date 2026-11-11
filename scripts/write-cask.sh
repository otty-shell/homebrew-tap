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

  zap trash: "~/.config/otty"

  caveats <<~EOS
    otty is not notarized by Apple, so macOS blocks its first launch.
    To allow it, do one of these:
      1. Open otty, then go to System Settings → Privacy & Security
         and click "Open Anyway".
      2. Run: xattr -dr com.apple.quarantine "#{appdir}/otty.app"
  EOS
end
EOF

echo "Wrote $CASK_PATH for otty $VERSION"
