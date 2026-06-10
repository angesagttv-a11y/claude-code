#!/bin/bash
set -e

SKILL_NAME="listingpro-wordpress-portal-master"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.claude/skills/$SKILL_NAME"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "ERROR: Skill source not found at $SOURCE_DIR"
  exit 1
fi

TARGET_DIR="${1:-$HOME/.claude/skills/$SKILL_NAME}"

mkdir -p "$(dirname "$TARGET_DIR")"
rm -rf "$TARGET_DIR"
cp -r "$SOURCE_DIR" "$TARGET_DIR"

echo "Installed $SKILL_NAME to $TARGET_DIR"
