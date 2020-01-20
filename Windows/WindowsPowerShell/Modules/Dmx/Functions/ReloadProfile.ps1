function ReloadProfile {
    Write-Output "Reloads profile"
    Remove-Module Dmx
    . $PROFILE
}

Set-Alias -Name reload -Value ReloadProfile