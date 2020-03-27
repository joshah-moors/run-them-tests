#!/usr/bin/env pwsh

$repoPath = "C:\Users\Joshah\Desktop\Git Repo"

#$overrideRepoPath = $args[0]
#
#If ($overrideRepoPath -ne $Null) {
#    $repoPath = $overrideRepoPath
#}

Set-Location $repoPath


$passArray = New-Object System.Collections.ArrayList
$failArray = New-Object System.Collections.ArrayList

#$workingDir = Get-Location
Write-Output "`nFinding tests to run in: $($repoPath)`n`n"

$subDirs = Get-ChildItem -Path $repoPath

foreach ($dir in $subDirs) { 
    Write-Output "`nWorking on $($dir)\tests"
    If (Test-Path $dir\tests) {
        #Write-Output $dir
        $testFiles = Get-ChildItem -Path $dir\tests
        #Write-Output $testFiles
        $pyFileFound = $false
        foreach ($file in $testFiles) {
            $extn = [IO.Path]::GetExtension($file)
            If ($extn -eq ".py" )
            {
                $pyFileFound = $true
                break
            }
        }
        If ($pyFileFound) {
            Write-Output "Python tests present in: $($dir)"

            # change directory
            Push-Location $dir
            
            pytest

            If ($LASTEXITCODE -eq 0) {
                $passArray.Add($dir)
            }
            else {
                $failArray.Add($dir)
            }
            
            # Back to repo root
            Pop-Location  
        }
    }
}

Write-Output "`n`n`n----------------    SUMMARY    ----------------`n"

If ($passArray.count -gt 0) {
    Write-Output "PASS-LIST:`n"
    foreach ($dir in $passArray) {
        Write-Output "`t$($dir): PASSED"
    }
}

If ($passArray.count -gt 0) {
    Write-Output "`nFAILURES:`n"
    foreach ($dir in $failArray) {
        Write-Output "`t$($dir): FAILED"
    }
}

Write-Output "`n`n"
