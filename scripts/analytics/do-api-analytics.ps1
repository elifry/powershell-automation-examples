# Returns the file path of the output file so that the calling script does not have to worry about tracking the output file path
function DoAnalytics ($demoFlag) {
    $repoPath = $(git rev-parse --show-toplevel)
    $outputFolder = "$repoPath\scripts\output"
    $resultsFileName = "api-results.md"
    $resultsFilePath = "$outputFolder\$resultsFileName"

    if ($demoFlag -eq $true) { Write-Host "Demo flag is on" }

    if ($demoFlag -eq $true) { Write-Host "API Token is: '$API_TOKEN'" } # Loaded from env file, don't actually print this in a real script

    # Create the output folder if it does not exist
    if (-not (Test-Path $outputFolder)) { New-Item -ItemType Directory -Path $outputFolder | Out-Null }

    # Force create (replace) the results file
    New-Item -Path "$outputFolder" -Name $resultsFileName -ItemType "file" -Value "" -Force | Out-Null
    
    # Start building the markdown file, using replacements. Note that backticks must be escaped with another backtick.
    $header = "Api Analytics for XYZ"
    $generalInfo = "This is a general information section.`n`nThis is a new line.`n`nAn example of a ``code snippet`` within the output.`n`n> Note: This is a note.`n`n- This is a bullet point.`n- This is another bullet point."
    $footer = "---`n`nThis is the footer section."
    $markdown = $(Get-Content -Path "$repoPath\scripts\markdown-snippets\template-analytics.md" -Encoding UTF8 -Raw) -replace "<header>", $header -replace "<general-info>", $generalInfo -replace "<footer>", $footer
    
    # Do work - get results (simulated)
    $results = "This is a simulated result.`n`nThis is a new line.`n`nAn example of a ``code snippet`` within the output.`n`n> Note: This is a note.`n`n- This is a bullet point.`n- This is another bullet point.`n`n"
    $results = $results + "### Full Data`n`n"
    $results = $results + "| Column 1 | Column 2 | Column 3 |`n| --- | --- | --- |`n"
    $data = [ordered]@{
        1 = @("Row 1, Column 1", "Row 1, Column 2", "Row 1, Column 3")
        2 = @("Row 2, Column 1", "Row 2, Column 2", "Row 2, Column 3")
        3 = @("Row 3, Column 1", "Row 3, Column 2", "Row 3, Column 3")
        4 = @("Row 4, Column 1", "Row 4, Column 2", "Row 4, Column 3")
    }
    foreach ($row in $data.GetEnumerator()) {
        $results = $results + "| " + $row.Value[0] + " | " + $row.Value[1] + " | " + $row.Value[2] + " |`n"
    }
    $markdown = $markdown.Replace("<results>", $results)

    Add-Content -Path $resultsFilePath -Value $markdown

    return $resultsFilePath
}