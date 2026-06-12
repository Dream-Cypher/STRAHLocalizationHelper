<#
.SYNOPSIS
    Builds STRAHLocalizationHelper into a self-contained, portable dist/ folder.

.DESCRIPTION
    - Cleans previous build output (project bin/obj and dist/) for a fresh build.
    - Publishes a self-contained win-x64 build to a top-level dist/ folder.
    - Verifies the exe, native Texture2DDecoderNative.dll, and config.json are present.
    - Optionally mirrors dist/ into a sibling repo's tools/ folder (default: ../STRAHLocalization).

.PARAMETER DestRepo
    Path to the sibling localization repo to copy the build into (under tools/).
    Pass an empty string or a non-existent path to skip this step.

.EXAMPLE
    ./build.ps1
    ./build.ps1 -DestRepo ../STRAHLocalization
#>
param(
    [string]$DestRepo = "../STRAHLocalization"
)

$ErrorActionPreference = "Stop"

$RepoRoot = $PSScriptRoot
$Project = Join-Path $RepoRoot "STRAHLocalizationHelper/src/STRAHLocalizationHelper.csproj"
$DistDir = Join-Path $RepoRoot "dist"
$ProjectDir = Join-Path $RepoRoot "STRAHLocalizationHelper/src"

Write-Host "==> Cleaning previous build output" -ForegroundColor Cyan
if (Test-Path $DistDir) {
    Remove-Item $DistDir -Recurse -Force
}
foreach ($sub in @("bin", "obj")) {
    $path = Join-Path $ProjectDir $sub
    if (Test-Path $path) {
        Remove-Item $path -Recurse -Force
    }
}

Write-Host "==> Publishing self-contained win-x64 build to dist/" -ForegroundColor Cyan
dotnet publish $Project -c Release -r win-x64 -o $DistDir

Write-Host "==> Verifying build output" -ForegroundColor Cyan
$RequiredFiles = @(
    "STRAHLocalizationHelper.exe",
    "x64/Texture2DDecoderNative.dll",
    "config.json"
)
$missing = @()
foreach ($file in $RequiredFiles) {
    $path = Join-Path $DistDir $file
    if (-not (Test-Path $path)) {
        $missing += $file
    }
}
if ($missing.Count -gt 0) {
    throw "Build output is missing required file(s): $($missing -join ', ')"
}
Write-Host "All required files present in dist/" -ForegroundColor Green

if ($DestRepo -and (Test-Path $DestRepo)) {
    $ToolsDir = Join-Path $DestRepo "tools"
    Write-Host "==> Copying dist/ to $ToolsDir" -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $ToolsDir | Out-Null
    Copy-Item "$DistDir/*" $ToolsDir -Recurse -Force
    Write-Host "Copied build to $ToolsDir" -ForegroundColor Green
}
else {
    Write-Host "==> Skipping copy to sibling repo (not found: $DestRepo)" -ForegroundColor Yellow
}

Write-Host "==> Done. Run: $DistDir/STRAHLocalizationHelper.exe" -ForegroundColor Green
