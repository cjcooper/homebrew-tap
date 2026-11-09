# cjcooper/homebrew-tap

Homebrew tap for cjcooper's apps.

## Install

```sh
brew install --cask cjcooper/tap/scuttle
brew install --cask cjcooper/tap/gestalt
brew install --cask cjcooper/tap/subduer
```

Or tap first:

```sh
brew tap cjcooper/tap
brew install --cask scuttle gestalt subduer
```

All three are Apple Silicon only.

## Casks

| Cask      | Description                                                           |
| --------- | --------------------------------------------------------------------- |
| `scuttle` | Menu bar controller for Colima, Docker and similar container runtimes |
| `gestalt` | Desktop runner for OpenTofu across a folder tree                      |
| `subduer` | Desktop app for browsing and controlling Kubernetes clusters          |

## Releasing a new version

Each app repo has the same two release scripts, in `tools/` (scuttle,
subduer) or `scripts/` (gestalt).

1. In the app's repo, on `main` on an Apple Silicon Mac:

   ```sh
   tools/build-signed.sh      # bump, sign, notarize, staple, tag; writes the .dmg and .dmg.sha256
   tools/publish-release.sh   # verify, push main + tag, create the GitHub release
   ```

   `publish-release.sh` prints the `brew bump-cask-pr` command to run next.
2. Update the cask (`<app>` is `scuttle`, `gestalt` or `subduer`):

   ```sh
   brew bump-cask-pr --version <version> --sha256 <sha256> cjcooper/tap/<app>
   ```

   or edit `Casks/<app>.rb` by hand: set `version` and `sha256` (from
   `<App>_<version>_aarch64.dmg.sha256`).
3. Check it: `brew audit --cask --strict cjcooper/tap/<app>` and
   `brew install --cask cjcooper/tap/<app>`.
