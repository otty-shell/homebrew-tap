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

otty opens right after install, nothing else is needed.

Why the cask does extra work here: otty is not notarized by Apple. macOS puts
a "quarantine" mark on every downloaded app, and for an app that is not
notarized it then refuses to start it with the message "otty is damaged and
can't be opened". The app is not damaged, and **Open Anyway** in System
Settings does not appear for this message.

So after every install and upgrade the cask removes the mark with:

```sh
xattr -dr com.apple.quarantine /Applications/otty.app
```

If you installed otty from the DMG by hand, run this command yourself once.

## How the cask is updated

The `Update otty cask` workflow runs every 6 hours and can also be started by
hand from the Actions tab. When the latest published otty release is newer
than `Casks/otty.rb`, it downloads both macOS DMGs, computes their checksums,
rewrites the cask with `scripts/write-cask.sh` and pushes the change.

The script expects the DMG names made by otty's `scripts/macos/package.sh`:
`otty-<version>-aarch64-apple-darwin.dmg` and
`otty-<version>-x86_64-apple-darwin.dmg`. If that naming changes, change the
`url` line in `scripts/write-cask.sh` too.
