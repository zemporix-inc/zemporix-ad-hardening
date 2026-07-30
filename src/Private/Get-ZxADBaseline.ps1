function Get-ZxADBaseline {
    param([string]$Path)
    $root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $resolved = if (Test-Path $Path) { $Path } else { Join-Path $root "baselines/$Path.json" }
    if (-not (Test-Path $resolved)) { throw "AD baseline bulunamadı: $Path" }
    Get-Content $resolved -Raw | ConvertFrom-Json
}
