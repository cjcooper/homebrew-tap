#!/usr/bin/env bash
# Bump this tap's casks to each app's latest GitHub release and push.
# It changes only this repo: Homebrew's tap copy and installed apps are untouched.
#
#   bump.sh                     every cask in Casks/
#   bump.sh scuttle subduer     only these casks
#   bump.sh --dry-run           show what would change; edit/push nothing
#   bump.sh --co-author "Name <email>"   add a Co-Authored-By trailer
#
# Works on the checkout this script lives in. The latest version comes from
# github.com/<owner>/<app>/releases/latest (what the casks' livecheck
# :github_latest uses). The script fetches that release's .sha256, downloads
# the dmg, checks they match, and rewrites `version` and `sha256`. All bumps
# go in one commit on main, which is pushed.
set -euo pipefail

die() { echo "error: $*" >&2; exit 1; }

dry_run=0; co_author=""; casks=()
while (( $# )); do
  case "$1" in
    --dry-run) dry_run=1 ;;
    --co-author) shift; co_author="${1:?--co-author needs a value}"
                 co_author="${co_author#Co-Authored-By: }" ;;
    -h|--help) sed -n '2,14p' "$0"; exit 0 ;;
    -*) die "unknown option: $1" ;;
    *) casks+=("$1") ;;
  esac
  shift
done

repo="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
cd "$repo"
[[ -d Casks ]] || die "no Casks/ in $repo"

# --- this checkout: on main, casks clean, even with origin ------------------
[[ "$(git symbolic-ref --short HEAD)" == main ]] || die "$repo isn't on main"
[[ -z "$(git status --porcelain -- Casks)" ]] || die "Casks/ has uncommitted changes"
# fetch + merge rather than pull: pull.rebase refuses to run with anything
# staged, even files unrelated to Casks/.
git fetch -q origin main || die "can't fetch origin"
if [[ "$(git rev-parse HEAD)" != "$(git rev-parse origin/main)" ]]; then
  git merge -q --ff-only origin/main || die "can't fast-forward main from origin"
fi
[[ "$(git rev-parse HEAD)" == "$(git rev-parse origin/main)" ]] \
  || die "main has unpushed commits; push or drop them first"

if (( ${#casks[@]} == 0 )); then
  for f in Casks/*.rb; do casks+=("$(basename "$f" .rb)"); done
fi

# --- find and verify bumps --------------------------------------------------
bumped=(); summary=()
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
for c in "${casks[@]}"; do
  f="Casks/$c.rb"
  [[ -f "$f" ]] || die "no cask $f"
  cur="$(sed -n 's/^  version "\(.*\)"$/\1/p' "$f" | head -1)"
  home="$(sed -n 's|^  homepage "https://github.com/\([^"]*\)"$|\1|p' "$f" | head -1)"
  [[ -n "$cur" && -n "$home" ]] || die "$c: can't read version/homepage in $f"
  loc="$(curl -fsSI "https://github.com/$home/releases/latest" | tr -d '\r' \
         | sed -n 's|^[Ll]ocation: .*/releases/tag/v\{0,1\}\(.*\)$|\1|p')"
  [[ "$loc" =~ ^[0-9]+(\.[0-9]+)*$ ]] || die "$c: can't find latest release of $home"
  new="$loc"
  if [[ "$new" == "$cur" ]]; then
    echo "$c: $cur is current"
    continue
  fi
  [[ "$(printf '%s\n%s\n' "$cur" "$new" | sort -V | tail -1)" == "$new" ]] \
    || die "$c: cask has $cur, newer than GitHub's latest $new"

  tmpl="$(sed -n 's/^  url "\(.*\)".*$/\1/p' "$f" | head -1)"
  [[ -n "$tmpl" ]] || die "$c: can't find url line in $f"
  url="${tmpl//\#\{version\}/$new}"

  echo "$c: $cur -> $new, checking $url"
  want="$(curl -fsSL "$url.sha256" | cut -d' ' -f1)" || die "$c: no $url.sha256 (release not fully published?)"
  [[ "$want" =~ ^[0-9a-f]{64}$ ]] || die "$c: bad .sha256 contents"
  curl -fsSL "$url" -o "$tmp/$c.dmg" || die "$c: download failed: $url"
  got="$(shasum -a 256 "$tmp/$c.dmg" | cut -d' ' -f1)"
  [[ "$got" == "$want" ]] || die "$c: dmg SHA-256 $got doesn't match published $want"
  echo "$c: SHA-256 $got verified"

  if (( ! dry_run )); then
    sed -i '' -E \
      -e "s/^  version \"[^\"]*\"\$/  version \"$new\"/" \
      -e "s/^  sha256 \"[0-9a-f]{64}\"\$/  sha256 \"$got\"/" "$f"
    grep -q "^  version \"$new\"\$" "$f" && grep -q "^  sha256 \"$got\"\$" "$f" \
      || die "$c: couldn't rewrite version/sha256 in $f"
  fi
  bumped+=("$c"); summary+=("$c cask to $new")
done

join() { local out="" s; for s in "$@"; do out+="${out:+, }$s"; done; echo "$out"; }

if (( ${#bumped[@]} == 0 )); then
  echo "Nothing to bump."
elif (( dry_run )); then
  echo "Dry run: would bump $(join "${summary[@]}"), commit and push."
  exit 0
else
  files=(); for c in "${bumped[@]}"; do files+=("Casks/$c.rb"); done
  brew style "${files[@]}" >/dev/null || die "brew style failed; fix and commit by hand"
  msg="fix: bump $(join "${summary[@]}")"
  [[ -n "$co_author" ]] && msg+=$'\n\n'"Co-Authored-By: $co_author"
  git add -- "${files[@]}"
  # Commit only the casks, leaving anything else staged alone.
  git commit -q -m "$msg" -- "${files[@]}"
  git push -q origin main
  echo "Pushed $(git log --oneline -1)"
fi
