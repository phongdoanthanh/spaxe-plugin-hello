#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
checker="$repo_root/scripts/check-identity.sh"
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT

write_fixture() {
  local repo_url="$1"
  local sdk_name="${2:-@spxdev/plugin-sdk}"
  mkdir -p "$fixture"
  cat > "$fixture/manifest.yaml" <<EOF
id: "spxdev-plugin-hello"
repo_url: "$repo_url"
EOF
  cat > "$fixture/README.md" <<'EOF'
# spaxe-plugin-hello

A plugin for Spaxe Code. The installed ID remains `spxdev-plugin-hello`.
EOF
  cat > "$fixture/Makefile" <<'EOF'
PKG_OUT := spxdev-plugin-hello-$(VERSION).tar.gz
EOF
  cat > "$fixture/package.json" <<EOF
{"name":"spxdev-plugin-hello-contract-tests","devDependencies":{"$sdk_name":"file:../spxdev/apps/packages/plugin-sdk"}}
EOF
}

write_fixture "https://github.com/phongdoanthanh/spaxe-plugin-hello"
bash "$checker" "$fixture"

write_fixture "https://github.com/phongdoanthanh/spxdev-plugin-hello"
if bash "$checker" "$fixture" >/dev/null 2>&1; then
  echo "expected old repository URL to be rejected" >&2
  exit 1
fi

write_fixture "https://github.com/phongdoanthanh/spaxe-plugin-hello" "@kandev/plugin-sdk"
if bash "$checker" "$fixture" >/dev/null 2>&1; then
  echo "expected stale upstream SDK package name to be rejected" >&2
  exit 1
fi

echo "hello plugin identity checks passed"
