# Remote one-liner installer (Windows, no clone needed):
#   irm https://raw.githubusercontent.com/4irF1ux/extended-cliamp-themes/main/install-remote.ps1 | iex
# Optional before running:
#   $env:ECT_ONLY="onedark,flexoki-dark"  # default: all
#   $env:ECT_REF="main"
$repo = "4irF1ux/extended-cliamp-themes"
$ref = if ($env:ECT_REF) { $env:ECT_REF } else { "main" }

if ($env:CLIAMP_CONFIG_DIR) { $dest = "$env:CLIAMP_CONFIG_DIR\themes" }
elseif ($env:XDG_CONFIG_HOME) { $dest = "$env:XDG_CONFIG_HOME\cliamp\themes" }
elseif ($env:HOME) { $dest = "$env:HOME\.config\cliamp\themes" }
else { $dest = "$env:APPDATA\cliamp\themes" }

$tmp = Join-Path $env:TEMP "ect-install"
$zip = Join-Path $tmp "repo.zip"
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
Invoke-WebRequest "https://github.com/$repo/archive/refs/heads/$ref.zip" -OutFile $zip
Expand-Archive $zip -DestinationPath $tmp -Force
$src = Join-Path $tmp "extended-cliamp-themes-$ref\themes"

$files = if ($env:ECT_ONLY) {
  $env:ECT_ONLY.Split(",") | ForEach-Object { Join-Path $src "$($_.Trim()).toml" }
} else {
  Get-ChildItem "$src\*.toml" | ForEach-Object { $_.FullName }
}

New-Item -ItemType Directory -Force -Path $dest | Out-Null
foreach ($f in $files) {
  if (-not (Test-Path $f)) { Write-Error "unknown theme: $f"; exit 1 }
  Copy-Item $f $dest -Force
  Write-Output "installed: $([IO.Path]::GetFileNameWithoutExtension($f)) -> $dest\"
}
Remove-Item $tmp -Recurse -Force
Write-Output 'done. try: cliamp --start-theme "onedark"'
