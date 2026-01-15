# dotfiles-windows

My personal dotfile collection for Windows.

# How to install

1. Ensure a Nerd Font is installed for glyph (icon) support such as
  - Cascadia Code (PreInstalled in Windows 11 Terminal)
  - JetBrains Mono
  - Hack
2. Run `Install.ps1`

# PowerShell Profile

This PowerShell profile is for PowerShell Core (v6+). Windows Terminal is required for proper rendering. 

My PowerShell profile includes:

- PSReadLine: for predictive autocomplete predictions
- Git aliases: my most commonly used aliases
- PSFzf: File and Command Finder
  - Ctrl+t: File Search  
  - Ctrl+r: Command Search through PSReadline History
  - Alt+c: Directory Search
- Zoxide: Use `z` command to jump to directories
- Starship: Minimal and Fast Cursor Prompt. Fast Git Status in Prompt
- Plus many of my favorite aliases and functions
  - Unix Based Utility Functions: cat, tail, sudo, touch, unzip, zip
  - ZFS Based Navigation Aliases: `..`, and `...` to go up one or two directories
  - And More
