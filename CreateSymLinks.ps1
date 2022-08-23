#Requires -RunAsAdministrator
[CmdletBinding()]
param (
    [Parameter(HelpMessage="Force delete existing destination")]
    [Switch]
    $Force
)

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
    [System.Tuple]::Create(".\mpv\mpv.conf","$env:APPDATA\mpv\mpv.conf")
    [System.Tuple]::Create(".\mpv\input.conf","$env:APPDATA\mpv\input.conf")
    [System.Tuple]::Create(".\mpv\shaders","$env:APPDATA\mpv\shaders")
    # mpv.net links
    [System.Tuple]::Create(".\mpv\mpv.conf","$env:APPDATA\mpv.net\mpv.conf")
    [System.Tuple]::Create(".\mpv\input.conf","$env:APPDATA\mpv.net\input.conf")
    [System.Tuple]::Create(".\mpv\shaders","$env:APPDATA\mpv.net\shaders")
)

Push-Location $PsScriptRoot
foreach ($link in $symLinks) {
    $source = $link.Item1
    $destination = $link.Item2

    if (Test-Path $destination) {
        $msg = "Destination exists for: $destination.`nDelete? y/n"
        $userInput = ""
        if ($Force) {
            $userInput = "y"
        }

        while ($userInput -notmatch "[yn]" ) {
            $userInput = Read-Host $msg 
        }

        if ($userInput -eq "y") {
            Remove-Item -Recurse $destination
        }
        else {
            Write-Warning "Did not delete existing destination: $destination"
        }
    }
    New-SymLink -Source $link.Item1 -Destination $link.Item2
}
Pop-Location