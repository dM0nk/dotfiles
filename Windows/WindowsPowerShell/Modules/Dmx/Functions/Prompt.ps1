
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

Import-Module posh-git
$global:GitPromptSettings.BeforeText = '['
$global:GitPromptSettings.AfterText = '] '
function prompt {
    
    Write-Host (Get-Date -Format G) -NoNewline -ForegroundColor DarkMagenta
    Write-Host " :: " -NoNewline -ForegroundColor DarkGray
    $admin = Test-Administrator
    if ($admin) {
        Write-Host "$env:USERNAME@" -NoNewline -ForegroundColor DarkRed
        Write-Host "$env:COMPUTERNAME" -NoNewline -ForegroundColor Magenta
    }
    else {
        Write-Host "$env:USERNAME@" -NoNewline -ForegroundColor DarkYellow
        Write-Host "$env:COMPUTERNAME" -NoNewline -ForegroundColor Magenta
    }
    Write-Host " :: " -NoNewline -ForegroundColor DarkGray

    $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    if ($curPath.ToLower().StartsWith($Home.ToLower())) {
        $curPath = "~" + $curPath.SubString($Home.Length)
    }

    Write-Host $curPath -NoNewline -ForegroundColor Blue
    Write-Host " :: " -NoNewline -ForegroundColor DarkGray
    
    Write-VcsStatus
    Write-Host ""  -ForegroundColor DarkGray
    
}

function cddash {
    if ($args[0] -eq '-') {
        $pwd = $OLDPWD;
    }
    else {
        $pwd = $args[0];
    }
    $tmp = Get-Location;

    if ($pwd) {
        Set-Location $pwd;
    }
    Set-Variable -Name OLDPWD -Value $tmp -Scope global;
}


# Colors on dir
Import-Module Get-ChildItemColor

Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope


# Zsh like prompt
Import-Module PSReadLine
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
Set-PSReadLineOption -MaximumHistoryCount 4000
# history substring search
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Tab completion
Set-PSReadlineKeyHandler -Chord 'Shift+Tab' -Function Complete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-Alias -Name cd -value cddash -Option AllScope
