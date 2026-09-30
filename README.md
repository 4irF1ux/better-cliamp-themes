# better-cliamp-themes

Extra themes for [cliamp](https://github.com/bjarneo/cliamp). Drop-in files, no rebuild needed — user themes override built-ins with the same name.

## Themes

| Theme | Source |
|---|---|
| `rose-pine` | Rosé Pine Main (dark). Overrides the built-in light one on purpose |
| `rose-pine-moon` | Rosé Pine Moon |
| `rose-pine-dawn` | Rosé Pine Dawn (light) |
| `gruvbox-material-hard` | Gruvbox Material dark, hard contrast (`bg #1D2021`) |
| `gruvbox-material-soft` | Gruvbox Material dark, soft contrast (`bg #32302F`) |
| `flexoki-dark` | Flexoki dark |
| `solarized-dark` | Solarized dark |
| `onedark` | Atom OneDark |

## Install

No clone needed (public repo):

```powershell
irm https://raw.githubusercontent.com/4irF1ux/better-cliamp-themes/main/install-remote.ps1 | iex
```

```sh
curl -fsSL https://raw.githubusercontent.com/4irF1ux/better-cliamp-themes/main/install-remote.sh | sh
```

Only some themes:

```powershell
$env:BCT_ONLY="rose-pine-moon,onedark"
irm https://raw.githubusercontent.com/4irF1ux/better-cliamp-themes/main/install-remote.ps1 | iex
```

```sh
BCT_ONLY="rose-pine-moon,onedark" curl -fsSL https://raw.githubusercontent.com/4irF1ux/better-cliamp-themes/main/install-remote.sh | sh
```

From a clone (alternative):

```powershell
.\install.ps1 --all
.\install.ps1 --only rose-pine-moon,onedark
.\install.ps1 --list
```

Script (Linux/macOS):

```sh
./install.sh --all
./install.sh --only=rose-pine-moon,onedark
./install.sh --list
```

Manual:

```powershell
Copy-Item themes/rose-pine-moon.toml "$env:APPDATA\cliamp\themes\" -Force
```

```sh
cp themes/rose-pine-moon.toml ~/.config/cliamp/themes/
```

Then:

```sh
cliamp theme list
cliamp --start-theme "rose-pine-moon"
```

Isolated testing (keeps your stable config untouched):

```powershell
$env:CLIAMP_CONFIG_DIR="$env:APPDATA\cliamp-dev"
.\install.ps1 --all
cliamp --start-theme "rose-pine-moon"
```

## Format

Seven keys, `bg` optional (empty = terminal background). The six foreground
keys are required in `#RRGGBB`:

```toml
bg = "#1a1b26"
accent = "#7aa2f7"
bright_fg = "#cfc9c2"
fg = "#848cb8"
green = "#9ece6a"
yellow = "#e0af68"
red = "#f7768e"
```

## Requests

Open an issue with the palette source and I'll take a look.
