# Runs all the available tests in the entire repo

$repoPath = $(git rev-parse --show-toplevel)

# Start timer
$startTime = Get-Date

. $repoPath\scripts\test-general-utilities\test-load-env.ps1 -file "$repoPath\scripts\test-general-utilities\sample.env"

. $repoPath\scripts\test-analytics\test-do-api-analytics.ps1

# Print timer in milliseconds
$endTime = Get-Date
$elapsedTime = $endTime - $startTime
Write-Host "Elapsed time: $($elapsedTime.TotalMilliseconds) ms"