# Modules
if ($null -ne (Get-InstalledModule z -ErrorAction Ignore)) {
   Import-Module z
}

if ($null -ne (Get-Command git*) ) {
   if ($null -ne (Get-InstalledModule git-aliases -ErrorAction Ignore)) {
      Import-Module git-aliases -DisableNameChecking
   }
   function gbd {
      git branch -d 
   }
   if ($null -ne (Get-InstalledModule posh-git -ErrorAction Ignore)) {
      Import-Module posh-git
   }
}

if ($null -ne (Get-InstalledModule oh-my-posh -ErrorAction Ignore)) {
   Import-Module oh-my-posh
   Set-PoshPrompt powerlevel10k_modern
}

# PSReadLine
Set-PSReadLineOption -PredictionSource History

# nvim
if (Get-Command -Name "nvim" -ErrorAction SilentlyContinue) {
   Set-Alias -Name vim -Value nvim
}

# Chocolatey profile
$env:ChocolateyInstall = "C:\ProgramData\chocolatey"
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Planet Bingo Profile
if (Test-Path "$PsScriptRoot\PB.Powershell_profile.ps1") {
   .  "$PsScriptRoot\PB.Powershell_profile.ps1"
}

function Unzip {
   param (
      [string]$FolderPath
   )
   7z.exe x $FolderPath
}

Function Zip {
      param (
         [string]$InputPath,
         [string]$OutputFile
      )
      if (-not (Test-Path $InputPath)) { Write-Error "Not a valid input path"; return; }
      $isFolder = Test-Path -Path $InputPath -PathType Container
      if ([string]::IsNullOrWhiteSpace($OutputFile)){
         if ($IsFolder){ $OutputFile = $InputPath.Trim().TrimEnd('\') + ".zip" }
         else { $OutputFile = [io.path]::GetFileNameWithoutExtension($InputPath) + ".zip" }
         echo "$InputPath $OutputFile"
         7z.exe a -tzip $OutputFile $InputPath
      } else { 
         $isFolder = Test-Path -Path $InputPath -PathType Container
         if ($OutputFile -like "*.zip") {
            7z.exe a -tzip $OutputFile
         } else {
            7z.exe a -tzip "$OutputFile.zip"
         }
         echo "$InputPath $OutputFile"
      }
   }

# Windows Aliases
$HostsFile = "c:\windows\system32\drivers\etc\hosts"

# Visual Studio Aliases
if (Test-Path  "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe") {
   Set-Alias -Name vs17 -Value "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe"
}
if (Test-Path "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe" ) {
   Set-Alias -Name vs19 -Value "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe" 
}
if (Test-Path "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" ) {
   Set-Alias -Name vs22 -Value "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" 
}

Set-Alias -Name e -Value explorer.exe

function touch {
   if ((Test-Path -Path ($args[0])) -eq $false) {
      set-content -Path ($args[0]) -Value ($null)
   }
}

function Copy-WorkingDir {
   Get-Location | Select-Object -ExpandProperty Path | Set-Clipboard
}

# Set-Location Aliases
function .. {
   Set-Location .. 
}

function ... {
   Set-Location ../.. 
}

# Remove-Item Aliases
function rmrf {
   param (
      $folder
   )
   Remove-Item -Recurse -Force $folder 
}

function tail {
   param (
      $file
   )
   Get-Content $file -Wait
}

function New-Guid {
   $guid = [Guid]::NewGuid()
   Set-Clipboard $guid
   Write-Host "Added New Guid to Clipboard: " -NoNewline
   Write-Host $guid -ForegroundColor Blue
}
