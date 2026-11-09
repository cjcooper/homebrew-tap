# cjcooper/homebrew-tap

Homebrew tap for cjcooper's apps.

## Install

```sh
brew install --cask cjcooper/tap/scuttle
```

Or tap first:

```sh
brew tap cjcooper/tap
brew install --cask scuttle
```

## Casks

| Cask      | Description                                                          |
| --------- | -------------------------------------------------------------------- |
| `scuttle` | Menu bar controller for Colima, Docker and similar container runtimes |

## Releasing a new Scuttle version

1. In the scuttle repo, on `main` on an Apple Silicon Mac:

   ```sh
   tools/build-signed.sh      # bump, sign, notarize, staple, tag; writes the .dmg and .dmg.sha256
   tools/publish-release.sh   # verify, push main + tag, create the GitHub release
   ```

   `publish-release.sh` prints the `brew bump-cask-pr` command to run next.
2. Update the cask:

   ```sh
   brew bump-cask-pr --version <version> --sha256 <sha256> cjcooper/tap/scuttle
   ```

   or edit `Casks/scuttle.rb` by hand: set `version` and `sha256` (from
   `Scuttle_<version>_aarch64.dmg.sha256`).
3. Check it: `brew audit --cask --strict cjcooper/tap/scuttle` and
   `brew install --cask cjcooper/tap/scuttle`.
