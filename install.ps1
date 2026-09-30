# better-cliamp-themes installer (Windows).
# Usage: .\install.ps1 [--all] [--only name1,name2] [--list]
# Destination mirrors cliamp's config resolution:
#   CLIAMP_CONFIG_DIR > XDG_CONFIG_HOME\cliamp > $HOME\.config\cliamp > %APPDATA%\cliamp
param([string]$only = "", [switch]$list, [switch]$all)

$src = Join-Path $PSScriptRoot "themes"
if ($list) { Get-ChildItem "$src\*.toml" | ForEach-Object { $_.BaseName }; exit 0 }

if ($env:CLIAMP_CONFIG_DIR) { $dest = "$env:CLIAMP_CONFIG_DIR\themes" }
elseif ($env:XDG_CONFIG_HOME) { $dest = "$env:XDG_CONFIG_HOME\cliamp\themes" }
elseif ($env:HOME) { $dest = "$env:HOME\.config\cliamp\themes" }
else { $dest = "$env:APPDATA\cliamp\themes" }

$files = if ($only) {
  $only.Split(",") | ForEach-Object { Join-Path $src "$($_.Trim()).toml" }
} else {
  Get-ChildItem "$src\*.toml" | ForEach-Object { $_.FullName }
}

New-Item -ItemType Directory -Force -Path $dest | Out-Null
foreach ($f in $files) {
  if (-not (Test-Path $f)) { Write-Error "unknown theme file: $f"; exit 1 }
  Copy-Item $f $dest -Force
  Write-Output "installed: $([IO.Path]::GetFileNameWithoutExtension($f)) -> $dest\"
}
