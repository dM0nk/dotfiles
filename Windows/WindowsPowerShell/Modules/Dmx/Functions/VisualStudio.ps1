function VisualStudio($sln = $null) {
    if ($sln) {
        & "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe" $sln
    }
    else {
        $slnFiles = Get-ChildItem *.sln
        $slnCount = @($slnFiles).Count
        if ($slnCount -eq 1) {
            & "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe" $slnFiles
        }
        elseif ($slnCount -gt 1) {
            write-warning "Mere end en SLN-fil"
            Write-Output $slnFiles | select-object -ExpandProperty name
        }
        else {
            write-warning "Kunne ikke finde en SLN-fil i denne folder"
        }
    }
}

Set-Alias -Name vs -Value VisualStudio