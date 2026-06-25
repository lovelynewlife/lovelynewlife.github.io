#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_root"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: current directory is not a git repository." >&2
  exit 1
fi

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  echo "Usage: ./commit-all.sh [commit message]"
  exit 0
fi

commit_message="${*:-}"

if [[ -z "${commit_message// }" ]]; then
  read -r -p "Commit message: " commit_message
fi

if [[ -z "${commit_message// }" ]]; then
  echo "Error: commit message cannot be empty." >&2
  exit 1
fi

git add -A

if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

git commit -m "$commit_message"

echo "Committed all changes."
