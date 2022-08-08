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
)

foreach ($link in $symLinks) {
    New-SymLink -Source $link.Item1 -Destination $link.Item2
}