#!/usr/bin/env bash
set -euo pipefail

codex_home="${CODEX_HOME:-$HOME/.codex}"
skill_name="beatsaber"
repo_url=""
ref=""
no_backup=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --codex-home PATH   Codex home folder. Defaults to $CODEX_HOME or ~/.codex.
  --skill-name NAME   Installed skill folder name. Defaults to beatsaber.
  --repo-url URL      Git repository URL to clone before installing.
  --ref REF           Optional branch, tag, or commit to install with --repo-url.
  --no-backup         Replace an existing install without keeping a timestamped backup.
  -h, --help          Show this help.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --codex-home) codex_home="$2"; shift 2 ;;
    --skill-name) skill_name="$2"; shift 2 ;;
    --repo-url) repo_url="$2"; shift 2 ;;
    --ref) ref="$2"; shift 2 ;;
    --no-backup) no_backup=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_root="$script_dir"
temp_root=""

cleanup() {
  if [ -n "$temp_root" ] && [ -d "$temp_root" ]; then
    rm -rf "$temp_root"
  fi
}
trap cleanup EXIT

if [ -n "$repo_url" ]; then
  command -v git >/dev/null 2>&1 || { echo "git is required when installing from --repo-url." >&2; exit 1; }
  temp_root="$(mktemp -d)"
  git clone --depth 1 "$repo_url" "$temp_root"
  if [ -n "$ref" ]; then
    git -C "$temp_root" fetch --depth 1 origin "$ref"
    git -C "$temp_root" checkout FETCH_HEAD
  fi
  source_root="$temp_root"
fi

if [ ! -f "$source_root/SKILL.md" ]; then
  echo "No SKILL.md found. Run from the skill repo root, or pass --repo-url <git-url>." >&2
  exit 1
fi

skills_root="$codex_home/skills"
destination="$skills_root/$skill_name"
mkdir -p "$skills_root"

source_abs="$(cd "$source_root" && pwd)"
dest_parent_abs="$(cd "$skills_root" && pwd)"
dest_abs="$dest_parent_abs/$skill_name"
self_install=0

if [ "$source_abs" = "$dest_abs" ]; then
  self_install=1
  staged_root="$(mktemp -d)"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --exclude .git "$source_root/" "$staged_root/"
  else
    tar -C "$source_root" --exclude .git -cf - . | tar -C "$staged_root" -xf -
  fi
  temp_root="$staged_root"
  source_root="$staged_root"
fi

if [ -e "$destination" ] && [ "$self_install" -eq 0 ]; then
  if [ "$no_backup" -eq 0 ]; then
    stamp="$(date +%Y%m%d-%H%M%S)"
    backup="$skills_root/$skill_name.backup-$stamp"
    mv "$destination" "$backup"
    echo "Backed up existing skill to: $backup"
  else
    rm -rf "$destination"
  fi
fi

mkdir -p "$destination"
if command -v rsync >/dev/null 2>&1; then
  rsync -a --exclude .git "$source_root/" "$destination/"
else
  tar -C "$source_root" --exclude .git -cf - . | tar -C "$destination" -xf -
fi

echo "Installed Beat Saber skill to: $destination"
echo 'Invoke it with: $beatsaber'
