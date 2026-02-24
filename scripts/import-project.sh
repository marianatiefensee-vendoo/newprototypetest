#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 /path/to/project.zip" >&2
  exit 1
fi

ZIP_PATH="$1"
if [[ ! -f "$ZIP_PATH" ]]; then
  echo "Archive not found: $ZIP_PATH" >&2
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

unzip -q "$ZIP_PATH" -d "$TMP_DIR/unzipped"

# Use first non-macos top-level folder/file set as source root.
SOURCE_ROOT="$TMP_DIR/unzipped"
shopt -s dotglob nullglob
entries=("$TMP_DIR"/unzipped/*)
if [[ ${#entries[@]} -eq 1 && -d "${entries[0]}" ]]; then
  SOURCE_ROOT="${entries[0]}"
fi

# Remove everything except .git and helper scaffolding.
find "$REPO_ROOT" -mindepth 1 -maxdepth 1 \
  ! -name '.git' \
  ! -name 'scripts' \
  ! -name 'README.md' \
  -exec rm -rf {} +

cp -a "$SOURCE_ROOT"/. "$REPO_ROOT"/

if [[ ! -f "$REPO_ROOT/vercel.json" ]]; then
  cat > "$REPO_ROOT/vercel.json" <<'JSON'
{
  "version": 2
}
JSON
fi

echo "Imported project from: $ZIP_PATH"
echo "Repository is ready for Vercel auto-detected builds."
