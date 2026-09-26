#!/usr/bin/env bash
set -euo pipefail

root="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

grep -Fqx 'id: "spxdev-plugin-hello"' "$root/manifest.yaml" || {
  echo "manifest ID must remain spxdev-plugin-hello" >&2
  exit 1
}
grep -Fqx 'repo_url: "https://github.com/phongdoanthanh/spaxe-plugin-hello"' "$root/manifest.yaml" || {
  echo "manifest repo_url must use the canonical spaxe-plugin-hello repository" >&2
  exit 1
}
grep -Fq '# spaxe-plugin-hello' "$root/README.md" || {
  echo "README must present the canonical repository name" >&2
  exit 1
}
grep -Fq 'spxdev-plugin-hello-$(VERSION).tar.gz' "$root/Makefile" || {
  echo "release asset name must preserve the stable plugin ID" >&2
  exit 1
}
node -e '
  const fs = require("node:fs");
  const pkg = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  if (pkg.name !== "spxdev-plugin-hello-contract-tests") process.exit(1);
  if (pkg.devDependencies?.["@spxdev/plugin-sdk"] !== "file:../spxdev/apps/packages/plugin-sdk") process.exit(1);
' "$root/package.json" || {
  echo "recipe contract tests must use the stable @spxdev SDK package" >&2
  exit 1
}
