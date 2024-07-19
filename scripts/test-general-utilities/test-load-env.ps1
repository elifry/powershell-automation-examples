$repoPath = $(git rev-parse --show-toplevel)

# Given an invalid file name, it should give an error message
function TestFileNotValid() {
    # Arrange
    if (Test-Path "$repoPath/.env") {
        Write-Host "Warning: skipping TestFileNotValid test. Local .env file is detected."
        return
    }

    # Act
    . $repoPath\scripts\general-utilities\load-env.ps1 -file garbagefilename *> temp.txt

    # Assert
    $lastLine = Get-Content temp.txt | Select-Object -Last 1
    Remove-Item -Path temp.txt -Force
    $expected = "Error: env file 'garbagefilename' not valid."
    if ("$lastLine" -eq $expected) {
        Write-Host "Passed: $($MyInvocation.MyCommand.Name)"
    } else {
        Write-Host "Failed: $($MyInvocation.MyCommand.Name)"
        Write-Host "`tExpected: '$expected'"
        Write-Host "`tActual: '$lastLine'"
    }
}

# Given a valid file with a token key=value pair, test that it gets loaded
# Note: do not set $SPECIAL_TEST_TOKEN = "" inside the function, it will make it so that the value of $SPECIAL_TEST_TOKEN does not get set by load-env
function TestEnvLoaded() {
    # Arrange - nothing to arrange
    # Act
    . $repoPath\scripts\general-utilities\load-env.ps1 -file "$repoPath\scripts\test-general-utilities\sample.env"

    # Assert
    $expected = "Special Test Value"
    if ("$SPECIAL_TEST_TOKEN" -eq "$expected") {
        Write-Host "Passed: $($MyInvocation.MyCommand.Name)"
    } else {
        Write-Host "Failed: $($MyInvocation.MyCommand.Name)"
        Write-Host "`tExpected: '$expected'"
        Write-Host "`tActual: '$SPECIAL_TEST_TOKEN'"
    }
}

TestFileNotValid
TestEnvLoaded