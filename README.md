# manifest

`latest.json` lists the latest release tag and asset URLs of every ps2build component. `ps2build update` reads it instead of querying the GitHub API once per component.

Served at https://raw.githubusercontent.com/ps2build/manifest/main/latest.json

## Updating

`.github/workflows/update.yml` regenerates the file from each component's latest release. It runs on a nightly schedule and when a component's release workflow sends a `component-released` repository dispatch:

```yaml
- name: Notify manifest
  run: |
    gh api repos/ps2build/manifest/dispatches -f event_type=component-released
  env:
    GH_TOKEN: ${{ secrets.MANIFEST_DISPATCH_TOKEN }}
```

`MANIFEST_DISPATCH_TOKEN` is a fine-grained token with `Contents: write` on this repository.
