#!/bin/sh
# Writes latest.json: the latest release tag and asset URLs of every component.
set -eu

owner="${MANIFEST_OWNER:-ps2build}"
components="ps2build toolchain llvm-toolchain ninja tools vcl cmake sdk-core sdk-world"
out="${1:-latest.json}"

tmp="$(mktemp)"
echo '{}' >"$tmp"
for name in $components; do
    rel="$(gh api "repos/$owner/$name/releases/latest" 2>/dev/null)" || {
        echo "no release for $name, skipping" >&2
        continue
    }
    entry="$(printf '%s' "$rel" | jq '{tag: .tag_name, assets: [.assets[] | {name: .name, url: .browser_download_url}]}')"
    jq --arg n "$name" --argjson e "$entry" '.[$n] = $e' "$tmp" >"$tmp.new"
    mv "$tmp.new" "$tmp"
done

jq '{version: 1, components: .}' "$tmp" >"$out"
rm -f "$tmp"
