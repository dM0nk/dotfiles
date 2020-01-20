###############################################################################################################
# Language     :  PowerShell 5.1
# Filename     :  dmx.psm1
# Autor        :  Mads Mørch Nielsen (https://github.com/dm0nk)
# Description  :  PowerShell-Module for all my functions
# Repository   :  https://github.com/dm0nk/dotfiles
###############################################################################################################

Get-ChildItem -Path "$PSScriptRoot\Functions" -Recurse | Where-Object { $_.Name.EndsWith(".ps1") } | ForEach-Object { . $_.FullName }