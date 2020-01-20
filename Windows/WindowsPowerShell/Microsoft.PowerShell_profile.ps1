Import-Module Dmx





function Checkout($branchName = $null) {
    
    if ($branchName -eq "List") {
        git branch -r
        return;
    }
    
    if ($branchName -eq $null) {
        git checkout master
    }

    else {
        git fetch --all
        $exists = & git rev-parse --verify $branchName 2>&1
        
        if ($exists -Like "fatal:*") {
            git checkout -b $branchName
        }
        else {
            git checkout $branchName
        }
    }


    git branch --set-upstream-to=origin/$branchName $branchName
}

# Set start directory
cd $HOME

Set-Alias g git

# I need this alias, so... DIE...
if (Test-Path -Path Alias:\gc) {
    Remove-Item Alias:\gc -Force
}

Set-Alias gc Checkout