# abbycli releases

Release artifacts and Claude Code plugins for **abbycli**, the Abby App/Report
authoring CLI. Source lives in a separate, private repository; this one exists so
downloads and plugin installs need no GitHub account.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/flash-financials/abbycli-dist/main/install.sh | sh
```

Verifies the download against `SHA256SUMS` and installs to `~/.abby/bin`. Pin a
version with `… | sh -s -- v0.9.4`.

**Windows:** download the `.zip` for your platform from
[Releases](https://github.com/flash-financials/abbycli-dist/releases) and put
`abbycli.exe` on your `PATH`.

Once installed, `abbycli update` takes later versions.

## Claude Code plugin

```
/plugin marketplace add flash-financials/abbycli-dist
/plugin install abby-authoring
```

It asks for your Abby deployment during install and wires the authoring tools up
with it. You still sign in once:

```bash
abbycli login --base-url https://your-abby-deployment
```

## Contents

| | |
| -- | -- |
| Releases | Platform archives and `SHA256SUMS` |
| `install.sh` | The installer the command above fetches |
| `plugins/`, `.claude-plugin/` | The Claude Code marketplace and its plugins |

Everything here is published by CI from the source repository. Changes made
directly to this repository are overwritten on the next release.
