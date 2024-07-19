$repoPath = $(git rev-parse --show-toplevel)

function ExampleOneTestAnalyticsProducesResult() {
    # Arrange
    if (Test-Path -Path $repoPath/scripts/output) {
        Remove-Item -Path $repoPath/scripts/output/*.* -Recurse
    }
    . $repoPath\scripts\general-utilities\load-env.ps1 -file "$repoPath\sample.env"
    . $repoPath\scripts\analytics\do-api-analytics.ps1

    # Act
    $resultsFilePath = DoAnalytics

    # Assert
    if ((Test-Path $resultsFilePath) -and (Get-Content $resultsFilePath).Length -gt 0) {
        Write-Host "Passed: $($MyInvocation.MyCommand.Name)"
    } else {
        Write-Host "Failed: $($MyInvocation.MyCommand.Name)"
    }
}

ExampleOneTestAnalyticsProducesResult