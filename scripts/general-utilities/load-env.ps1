param (
    [string]$file = "",
    [switch]$verbose = $false
)

# Set default if none is provided
if ($file -eq "") {
    $repoPath = $(git rev-parse --show-toplevel)
    $file = "$repoPath/.env"
}

if (-not (Test-Path $file)) {
    Write-Host "Error: env file '$file' not valid."
    return
}

if ($verbose -eq $true) { Write-Host "Loading env file '$file'." }

Get-Content $file | ForEach-Object {
    if ($_) {
        $envName, $envValue = $_.Trim().split('=',2)
        # Remove any leading and trailing quotes from the value
        $envValue = $envValue -replace '^"(.*)"$','$1'
        if ($verbose -eq $true) { Write-Host "Setting '$envName'='$envValue'" }
        Set-Variable -Name "global:$envName" -Value $envValue
    }
}
