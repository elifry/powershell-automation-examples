# Runs the "Example 1" related tests

$repoPath = $(git rev-parse --show-toplevel)

. $repoPath\scripts\test-general-utilities\test-load-env.ps1 -file "$repoPath\scripts\test-general-utilities\sample.env"

. $repoPath\scripts\test-analytics\test-do-api-analytics.ps1