# --- PSReadLine ---
if (Get-Module -ListAvailable PSReadLine) {
   Import-Module PSReadLine
   
   Set-PSReadLineOption -PredictionSource History
   Set-PSReadLineOption -PredictionViewStyle InlineView
   Set-PSReadLineOption -Colors @{ InlinePrediction = '#8a8a8a' }
}

# --- PowerShell Color Fixes ---
# Fix unreadable directory colors in ls (Get-ChildItem) for Terminal Color Schemes
$PSStyle.FileInfo.Directory = "`e[1;36m" # BoldCyan
# Fix hard to read "Symbolic Link" color
$PSStyle.FileInfo.SymbolicLink = "`e[1;35m"

# --- git aliases ---
$Global:GitLoaded = $false
function git {
    # 1. Capture args IMMEDIATELY to protect them from scope deletion
    $cmdArgs = $args

    if (-not $Global:GitLoaded) {
        # Import posh-git silently
        Import-Module posh-git -WarningAction SilentlyContinue -ErrorAction SilentlyContinue | Out-Null
        $Global:GitLoaded = $true
        
        # Remove this wrapper so future calls go straight to git.exe
        Remove-Item Function:\git -ErrorAction SilentlyContinue
    }
    
    # 2. Run git with the safely captured arguments
    & git.exe @cmdArgs
}

# Prevent conflict with built-in aliases
Remove-Alias gc -Force -ErrorAction SilentlyContinue
Remove-Alias gl -Force -ErrorAction SilentlyContinue
Remove-Alias gp -Force -ErrorAction SilentlyContinue

function gs { git status $args }
function ga { git add $args }
function gc { git commit -v $args }
function gco { git checkout $args }
function gp { git push $args }
function gd { git diff $args }
function gl { git pull $args }
function gst { git status $args }
function gsta { git stash add $args }
function gstp { git stash pop $args }
function gstl { git stash list $args }
function glo { git log --oneline --decorate $args }
function glog { git log --oneline --decorate --graph $args }

function gpsup {
    $branch = git branch --show-current
    if ($branch) {
      Write-Host "🚀 Pushing '$branch' to origin..." -ForegroundColor Cyan
      git push --set-upstream origin $branch
    } else {
      Write-Error "Not in a git repository or detached HEAD."
    }
}

# --- Utility Functions ---
function cat { if (Get-Command bat -EA 0) { bat $args } else { Get-Content $args } }
function e { explorer.exe $args }
function sudo { if (Get-Command gsudo.exe -EA 0) { gsudo $args } else { Write-Host "gsudo.exe is not installed" } }
# Set-Location Aliases
function .. { Set-Location ..  }
function ... { Set-Location ../..  }

function Unzip { param ( [string]$FolderPath) 7z.exe x $FolderPath }
Function Zip {
      param ( 
         [string]$InputPath,
         [string]$OutputFile)
      if (-not (Test-Path $InputPath)) {
         Write-Error "Not a valid input path";
         return;
      }
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

function touch {
   if (-not (Test-Path -Path $args[0])) {
      Set-Content -Path $args[0] -Value $null
   }
}

# Remove-Item Aliases
function rmrf {
   param (
      $folder
   )
   Remove-Item -Recurse -Force $folder 
}

function tail { param ( $file) Get-Content $file -Wait }

function New-Guid {
   $guid = [Guid]::NewGuid()
   Write-Output $guid
}

# Visual Studio Aliases
function vs17 {
   $path = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe"
   if (Test-Path $path) { Start-Process $path $args } else { Write-Error "VS 2017 not found." }
}
function vs19 {
   $path = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe"
   if (Test-Path $path) { Start-Process $path $args } else { Write-Error "VS 2019 not found." }
}
function vs22 {
   $path = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
   if (Test-Path $path) { Start-Process $path $args } else { Write-Error "VS 2022 not found." }
}

# --- Planet Bingo Profile ---
if (Test-Path "$PsScriptRoot\PB.Powershell_profile.ps1") {
   .  "$PsScriptRoot\PB.Powershell_profile.ps1"
}

# --- PSFzf ---
if (Get-Module -ListAvailable PSFzf -ErrorAction SilentlyContinue) {
   Import-Module PSFzf -DisableNameChecking

   # Set Keybindings
   # Ctrl+t: File Search
   # Ctrl+r: History Search
   # Alt+c: Directory Search
   Set-PsFzfOption `
        -PSReadlineChordProvider 'Ctrl+t' `
        -PSReadlineChordReverseHistory 'Ctrl+r' `
        -PSReadlineChordSetLocation 'Alt+c' `
        -ModulePrefix 'fzf'    
}

# --- Zoxide ---
# Documentation recommends this being added last
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
   Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# --- Starship ---
# Documentation recommends this being added last
if (Get-Command starship -ErrorAction SilentlyContinue) {
   Invoke-Expression (&starship init powershell)
}
