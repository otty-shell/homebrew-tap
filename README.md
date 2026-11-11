# otty Homebrew tap

This tap installs [otty](https://github.com/otty-shell/otty) on macOS
from the DMG files attached to otty releases.

## Install

```sh
brew install --cask otty-shell/tap/otty
```

Update with `brew upgrade --cask otty`, remove with `brew uninstall --cask otty`.
Add `--zap` to the uninstall command to also delete `~/.config/otty`.

## First launch

otty is not notarized by Apple, so macOS blocks it the first time you open it.
To allow it, do one of these once:

1. Open otty, then go to **System Settings → Privacy & Security** and click
   **Open Anyway**.
2. Run:

   ```sh
   xattr -dr com.apple.quarantine /Applications/otty.app
   ```

On macOS 15 and later, right-click → Open no longer skips this check.

## How the cask is updated

The `Update otty cask` workflow runs every 6 hours and can also be started by
hand from the Actions tab. When the latest published otty release is newer
than `Casks/otty.rb`, it downloads both macOS DMGs, computes their checksums,
rewrites the cask with `scripts/write-cask.sh` and pushes the change.

The script expects the DMG names made by otty's `scripts/macos/package.sh`:
`otty-<version>-aarch64-apple-darwin.dmg` and
`otty-<version>-x86_64-apple-darwin.dmg`. If that naming changes, change the
`url` line in `scripts/write-cask.sh` too.
