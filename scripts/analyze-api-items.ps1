param (
    [string]$token = "",
    [switch]$demo = $false
)

$repoPath = $(git rev-parse --show-toplevel)

# Load env
. $repoPath\scripts\general-utilities\load-env.ps1 -file "$repoPath\sample.env"

# Do analytics
. $repoPath\scripts\analytics\do-api-analytics.ps1
$resultsFilePath = DoAnalytics $demo

# Display markdown results
code $resultsFilePath
