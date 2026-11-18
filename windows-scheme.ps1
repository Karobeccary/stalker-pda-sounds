<#
S.T.A.L.K.E.R. PDA sound scheme for Windows 10/11.

Adds a "S.T.A.L.K.E.R. PDA" sound scheme: a copy of whatever sounds you have now, with
PDA chirps swapped in for notifications, alerts, devices and so on. Before switching,
your current sounds are saved as a "My sounds (before PDA)" scheme, so nothing is lost.
Both show up in Control Panel > Sound > Sounds > Sound Scheme.

  windows-scheme.ps1              install (or refresh) the PDA scheme and switch to it
  windows-scheme.ps1 -NoSwitch    install it but keep your current sounds
  windows-scheme.ps1 -Restore     switch back to your sounds from before PDA
  windows-scheme.ps1 -Remove      restore, then delete both schemes and the copied wavs

No admin needed: everything is under HKEY_CURRENT_USER plus %USERPROFILE%\Media\STALKER PDA.
To change which sound goes where, edit $map below and run it again.
#>
param([switch]$NoSwitch, [switch]$Restore, [switch]$Remove,
      [string]$Root = "HKCU:\AppEvents\Schemes")   # -Root is only for testing

$ErrorActionPreference = "Stop"
$id = ".StalkerPDA";  $label = "S.T.A.L.K.E.R. PDA"
$bak = ".StalkerPDABefore";  $bakLabel = "My sounds (before PDA)"
$wavSrc = @("sounds", "windows") | ForEach-Object { Join-Path $PSScriptRoot $_ } | Where-Object { Test-Path $_ } | Select-Object -First 1
$wavDir = Join-Path $env:USERPROFILE "Media\STALKER PDA"

# event -> wav (events under Apps\.Default unless written app\event)
$map = [ordered]@{
    ".Default"                     = "pda_tip"        # Default Beep
    "SystemAsterisk"               = "pda_tip"
    "SystemQuestion"               = "pda_tip"
    "SystemExclamation"            = "pda_objective"
    "SystemHand"                   = "pda_sos"        # Critical Stop
    "SystemNotification"           = "pda_news"
    "Notification.Default"         = "pda_news"       # toast notifications
    "Notification.IM"              = "pda_news"
    "Notification.Mail"            = "pda_news"
    "Notification.SMS"             = "pda_news"
    "MailBeep"                     = "pda_news"
    "Notification.Reminder"        = "pda_objective"
    "Notification.Proximity"       = "contact_1"
    "ProximityConnection"          = "contact_1"
    "MessageNudge"                 = "contact_1"
    "Notification.Looping.Alarm"   = "pda_alarm"
    "Notification.Looping.Alarm2"  = "bomb_timer"
    "Notification.Looping.Call"    = "radio_call"
    "DeviceConnect"                = "inv_slot"
    "DeviceDisconnect"             = "inv_drop"
    "DeviceFail"                   = "door_locked"
    "LowBatteryAlarm"              = "pda_alarm"
    "CriticalBatteryAlarm"         = "pda_sos"
    "WindowsUAC"                   = "power_switch"
    "PrintComplete"                = "mp_reward"
}

function Event-Keys { Get-ChildItem "$Root\Apps\*\*" | Where-Object { Test-Path "$($_.PSPath)\.Current" } }
function Current-Scheme { (Get-Item $Root).GetValue("") }

function Set-Default($path, $value) {
    if (-not (Test-Path $path)) { New-Item $path -Force | Out-Null }
    Set-Item $path -Value ([string]$value)
}

# copy one scheme's sounds into another (".Current" = what's playing now)
function Copy-Scheme($from, $to) {
    foreach ($ev in Event-Keys) {
        $src = "$($ev.PSPath)\$from"
        $val = if (Test-Path $src) { (Get-Item $src).GetValue("") } else { "" }
        Set-Default "$($ev.PSPath)\$to" $val
    }
}

function Switch-To($scheme, $name) {
    Copy-Scheme $scheme ".Current"
    Set-Item $Root -Value $scheme
    Write-Host "Sound scheme is now: $name"
}

function Drop-Scheme($scheme) {
    foreach ($ev in Get-ChildItem "$Root\Apps\*\*") { if (Test-Path "$($ev.PSPath)\$scheme") { Remove-Item "$($ev.PSPath)\$scheme" } }
    if (Test-Path "$Root\Names\$scheme") { Remove-Item "$Root\Names\$scheme" }
}

function Do-Restore {
    if (Test-Path "$Root\Names\$bak") { Switch-To $bak $bakLabel }
    else { Switch-To ".Default" "Windows Default" }
}

if ($Restore) { Do-Restore; return }

if ($Remove) {
    if ((Current-Scheme) -eq $id) { Do-Restore }
    Drop-Scheme $id
    if ((Current-Scheme) -ne $bak) { Drop-Scheme $bak }
    else { Write-Host "Kept '$bakLabel' since it's the active scheme now." }
    if (Test-Path $wavDir) { Remove-Item $wavDir -Recurse -Force }
    Write-Host "Removed the PDA scheme."
    return
}

if (-not $wavSrc) { throw "Can't find the 'sounds' folder next to this script." }
New-Item -ItemType Directory -Force $wavDir | Out-Null
Copy-Item "$wavSrc\*.wav" $wavDir -Force

# save the sounds you have now, unless PDA is what's playing (then keep the older backup)
if ((Current-Scheme) -ne $id) {
    Copy-Scheme ".Current" $bak
    Set-Default "$Root\Names\$bak" $bakLabel
    Write-Host "Saved your current sounds as '$bakLabel'."
}

# PDA scheme = your sounds from before, with the chirps laid over the top
$base = if (Test-Path "$Root\Names\$bak") { $bak } else { ".Current" }
Copy-Scheme $base $id
foreach ($k in $map.Keys) {
    $path = if ($k.Contains("\")) { "$Root\Apps\$k" } else { "$Root\Apps\.Default\$k" }
    Set-Default "$path\$id" (Join-Path $wavDir "$($map[$k]).wav")
    if (-not (Test-Path "$path\.Current")) { Set-Default "$path\.Current" "" }
}
Set-Default "$Root\Names\$id" $label
Write-Host "Installed '$label' ($($map.Count) PDA sounds, files in $wavDir)."

if (-not $NoSwitch) { Switch-To $id $label }
