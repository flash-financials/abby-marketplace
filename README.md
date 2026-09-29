# abby-marketplace

Releases and Claude Code plugins for **abbycli**, the Abby App/Report authoring
CLI. Source lives in a separate, private repository; this one is public so
downloads and plugin installs need no GitHub account.

## Claude Code plugin

Pick one environment — the binary talks to that deployment and nothing else —
and the plugin for your machine: `abbycli-mac` (Apple Silicon), `abbycli-windows`
(x64) or `abbycli-linux` (x64). Each release also ships them as zips
(`abbycli-<platform>-plugin-<version>.zip`) for **Settings → Plugins → Upload
local plugin** in the desktop app.

**prod** (`abby.fm`):

```
claude plugin marketplace add https://marketplace.abby.fm/marketplace.json
claude plugin install abbycli-mac@abby          # or abbycli-windows@abby / abbycli-linux@abby
```

**stg** (`stg.abby.am`):

```
claude plugin marketplace add https://marketplace.abby.fm/marketplace-stg.json
claude plugin install abbycli-mac@abby-stg      # or abbycli-windows@abby-stg / abbycli-linux@abby-stg
```

**dev** (`dev.abby.am`):

```
claude plugin marketplace add https://marketplace.abby.fm/marketplace-dev.json
claude plugin install abbycli-mac@abby-dev      # or abbycli-windows@abby-dev / abbycli-linux@abby-dev
```

`abbycli` ships inside the plugin. Restart Claude Code, or `/reload-plugins`,
after it finishes. Install exactly one of the three — they carry the same skills,
and two at once means duplicate skills.

Already installed? Refresh the same channel:

```
claude plugin marketplace update abby        # or abby-stg / abby-dev
claude plugin update abbycli-mac@abby        # the plugin you installed, on the same marketplace
```

## Standalone CLI (without Claude Code)

macOS and Linux:

```bash
curl -fsSL https://marketplace.abby.fm/install.sh | sh
```

If your network reaches github.com but not `marketplace.abby.fm`:

```bash
curl -fsSL https://github.com/flash-financials/abby-marketplace/releases/latest/download/install.sh | sh
```

Verifies the download against `SHA256SUMS` and installs to `~/.abby/bin`
(override with `ABBY_INSTALL_DIR`). Pin a version with `… | sh -s -- v1.0.0`.

**Windows:** download `abbycli_v<version>_windows_amd64.zip` from
[Releases](https://github.com/flash-financials/abby-marketplace/releases) and put
`abbycli.exe` on your `PATH`.

A standalone install updates itself with `abbycli update`.

## Contents

| | |
| -- | -- |
| Releases | Platform archives, plugin zips and `SHA256SUMS` |
| `marketplace.json`, `marketplace-stg.json`, `marketplace-dev.json` | Marketplace manifests for prod, stg and dev, served at `marketplace.abby.fm` |
| `install.sh` | The standalone installer above |
| `plugins/`, `.claude-plugin/` | The Claude Code marketplace and its plugins |

The release pipeline in the source repository publishes the releases, manifests
and `install.sh`. It does not touch this README — it is kept by hand, in step
with the install section of the source repository's README.
