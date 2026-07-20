<#
.SYNOPSIS
    Automated Windows Storage Cleanup Script
.DESCRIPTION
    Self-elevating PowerShell script that accurately calculates storage differentials
    while safely clearing temp folders, prefetch, and delivery optimization caches.
#>

# -----------------------------------------------------------------------------
# 1. Force Administrator Privileges
# -----------------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Requesting Administrator privileges..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# -----------------------------------------------------------------------------
# 2. Record Baseline Storage (64-bit precision)
# -----------------------------------------------------------------------------
$SystemDrive = $env:SystemDrive
$DriveInfo = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$SystemDrive'"
$SpaceStart = $DriveInfo.FreeSpace

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "           SYSTEM CLEANUP IN PROGRESS              " -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------------------------------------
# 3. Clean Target Paths Safely
# -----------------------------------------------------------------------------
$Targets = @(
    @{ Name = "[1/4] User Temporary Files";         Path = "$env:USERPROFILE\AppData\Local\Temp" },
    @{ Name = "[2/4] System Temporary Files";       Path = "$env:windir\Temp" },
    @{ Name = "[3/4] Prefetch Cache";               Path = "$env:windir\Prefetch" },
    @{ Name = "[4/4] Windows Update Downloads";     Path = "$env:windir\SoftwareDistribution\Download" }
)

foreach ($Target in $Targets) {
    Write-Host "Emptying $($Target.Name)..." -ForegroundColor White
    if (Test-Path $Target.Path) {
        # Get all underlying items to avoid deleting the root folder itself
        Get-ChildItem -Path $Target.Path -Recurse -Force -ErrorAction SilentlyContinue | 
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# -----------------------------------------------------------------------------
# 4. Calculate Ending Storage and Results
# -----------------------------------------------------------------------------
# Force a garbage collection and WMI refresh for storage accuracy
[GC]::Collect()
$DriveInfoRefresh = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$SystemDrive'"
$SpaceEnd = $DriveInfoRefresh.FreeSpace

$BytesSaved = $SpaceEnd - $SpaceStart
$MBSaved = [Math]::Round($BytesSaved / 1MB, 2)
$GBSaved = [Math]::Round($BytesSaved / 1GB, 2)

Write-Host ""
Write-Host "===================================================" -ForegroundColor Green
Write-Host "               CLEANUP COMPLETE                    " -ForegroundColor Green
if ($BytesSaved -le 0) {
    Write-Host "Storage status refreshed. No major junk found." -ForegroundColor Yellow
} else {
    Write-Host "Space Recovered: $MBSaved MB ($GBSaved GB)" -ForegroundColor Green
}
Write-Host "===================================================" -ForegroundColor Green
Write-Host ""

Read-Host "Press Enter to exit"
