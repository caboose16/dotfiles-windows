#Requires -RunAsAdministrator

function New-SymLink {
    param (
        [string] $Source,
        [string] $Destination
    )

    New-Item -Path $Destination -ItemType SymbolicLink -Value (Get-Item $Source).FullName -Force
}

$symLinks = @(
    # powershell links
    [System.Tuple]::Create(".\Microsoft.PowerShell_profile.ps1","~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1")

    # mpv links
    [System.Tuple]::Create(".\mpv\mpv.conf","$env:APPDATA\mpv.net\mpv.conf")
    [System.Tuple]::Create(".\mpv\input.conf","$env:APPDATA\mpv.net\input.conf")
    [System.Tuple]::Create(".\mpv\shaders","$env:APPDATA\mpv.net\shaders")
)

Push-Location $PsScriptRoot
foreach ($link in $symLinks) {
    New-SymLink -Source $link.Item1 -Destination $link.Item2
}
Pop-Location