---
name: bump-tap-casks
description: Update this tap's casks (Scuttle, Subduer, Gestalt) to each app's latest published GitHub release, push, and upgrade the installed apps. Use when the user asks to update/upgrade these apps to the latest version, says `brew upgrade` claims they're current but a newer release exists, or asks to bump a cask after an app's publish-release script ran.
---

# Bump tap casks and upgrade the apps

An app's `publish-release.sh` creates the GitHub release but leaves
`Casks/<app>.rb` alone, so `brew upgrade` keeps saying the old version is
latest. This skill does the cask step in the README's "Releasing a new
version", then the upgrade.

## The apps

| Cask      | App repo          | Release scripts | Bundle id                      | dmg asset                     |
| --------- | ----------------- | --------------- | ------------------------------ | ----------------------------- |
| `scuttle` | `cjcooper/scuttle` | `tools/`       | `com.it-problems.scuttle`      | `Scuttle_<v>_aarch64.dmg`     |
| `subduer` | `cjcooper/subduer` | `tools/`       | `com.it-problems.k8s-subduer`  | `Subduer_<v>_aarch64.dmg`     |
| `gestalt` | `cjcooper/gestalt` | `scripts/`     | `com.it-problems.gestalt`      | `Gestalt_<v>_aarch64.dmg`     |

Each release has a `<dmg>.sha256` next to the dmg. All are arm64-only.

## Run it

From this repo, on `main`:

```bash
.claude/skills/bump-tap-casks/bump.sh --co-author "<Name <email> from the session's attribution reminder>"
```

Pass cask names to limit it (`bump.sh gestalt`). Use `--dry-run` to check
first (it changes nothing, including Homebrew's tap copy and installed apps)
and `--no-upgrade` to change the tap only. A leading `Co-Authored-By: ` on the
`--co-author` value is stripped, so a whole trailer works too.

Pushing to the tap is outward-facing. If the user has already asked for the
update in this conversation, that counts as approval. Otherwise run
`--dry-run`, show the planned bumps, and confirm before the real run.

What the script does:

1. Requires this checkout on `main`, `Casks/` clean, no unpushed commits, then
   fast-forwards from origin. Other staged files are fine; they're left out of
   the commit.
2. For each cask, reads the latest release from
   `github.com/<repo>/releases/latest` (what livecheck `:github_latest` uses).
   For each newer one, it fetches `<dmg url>.sha256`, downloads the dmg,
   checks they match, and rewrites `version` and `sha256`.
3. Runs `brew style`, makes one commit on `main` and pushes it.
4. Fast-forwards Homebrew's own copy of the tap
   (`/opt/homebrew/Library/Taps/cjcooper/homebrew-tap`, a separate clone with
   an HTTPS remote) to `main`. If it's on another branch, it switches to
   `main` and keeps that branch.
5. Runs `brew upgrade --cask` for each installed cask whose version differs
   from the cask file (compared directly, with auto-update off, because
   `brew outdated` can print nothing during an auto-update).

## Exit codes

- `0`: done.
- `2`: an upgrade needs `sudo` (output line `NEEDS_SUDO`). The session can't
  type a password, so ask the user to run the printed command with the `!`
  prefix, e.g. `! brew upgrade --cask cjcooper/tap/scuttle`. This happens when
  the installed version's cask had an `uninstall delete:`, which runs as root.
  Scuttle ≤ 0.1.6 installs are like that. Their uninstall also unloads and
  deletes `~/Library/LaunchAgents/Scuttle.plist` before failing, so tell the
  user to open Scuttle once after upgrading to restore the login item.
- anything else: read the `error:` line. Common ones: uncommitted cask changes
  (look before touching them), no `.sha256` on the release (it isn't fully
  published), checksum mismatch (stop; don't override).

## Cask conventions to keep

- Put user-owned files (e.g. `~/Library/LaunchAgents/*.plist`) in
  `zap trash:`, not `uninstall delete:`, because `delete:` makes every
  upgrade ask for a password.
- Leave livecheck as `strategy :github_latest`. Releases must be marked
  "latest", which `publish-release.sh` does.
