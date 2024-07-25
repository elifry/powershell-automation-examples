# Returns the file path of the output file so that the calling script does not have to worry about tracking the output file path
function DoAnalytics ($demoFlag) {
    $repoPath = $(git rev-parse --show-toplevel)
    $resultsFileName = "api-results.md"
    if ($IsWindows) {
        $outputFolder = "$repoPath\scripts\output"
        $resultsFilePath = "$outputFolder\$resultsFileName"
    } else {
        $outputFolder = "$repoPath/scripts/output"
        $resultsFilePath = "$outputFolder/$resultsFileName"
    }

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


    # Simulated data using https://meowfacts.herokuapp.com/ sample API, hit 4 times for a new cat fact
    # Track the number of words, most common word, and most common letter

    $data = @{}
    $rows = 6 # Do X times

    for ($i = 0; $i -lt $rows; $i++) {

        # Hit the endpoint with GET
        $response = Invoke-WebRequest -Uri "https://meowfacts.herokuapp.com/" -Method Get -UseBasicParsing | ConvertFrom-Json
        $responseBody = $response.data

        # Split the response into words and get the count of the highest word
        $words = $responseBody.ToLower() -split " "
        $wordCount = @{}
        foreach ($word in $words) {
            if ($wordCount.ContainsKey($word)) {
                $wordCount[$word]++
            } else {
                $wordCount[$word] = 1
            }
        }
        $mostCommonWord = $wordCount.GetEnumerator() | Sort-Object -Property Value -Descending | Select-Object -First 1
        
        # If the word is only found once, it is not the most common word so just print a custom message
        if ($mostCommonWord.Value -eq 1) {
            $mostCommonWord = "No word found more than once"
        }

        # Get the most common letter
        $letters = $responseBody.ToLower() -replace " ", "" -split ""
        $letterCount = @{}
        foreach ($letter in $letters) {
            if ($letterCount.ContainsKey($letter)) {
                $letterCount[$letter]++
            } else {
                $letterCount[$letter] = 1
            }
        }
        $mostCommonLetter = $letterCount.GetEnumerator() | Sort-Object -Property Value -Descending | Select-Object -First 1

        # If the letter is only found once, it is not the most common letter so just print a custom message
        if ($mostCommonLetter.Value -eq 1) {
            $mostCommonLetter = "No letter found more than once"
        }

        # Add to $data in this format - 1 = @("Row 1, Column 1", "Row 1, Column 2", "Row 1, Column 3")
        $data[$i] = @($responseBody, "Most common word: '$mostCommonWord'", "Most common letter: '$mostCommonLetter'")
    }

    foreach ($row in $data.GetEnumerator()) {
        $results = $results + "| " + $row.Value[0] + " | " + $row.Value[1] + " | " + $row.Value[2] + " |`n"
    }
    $markdown = $markdown.Replace("<results>", $results)

    Add-Content -Path $resultsFilePath -Value $markdown

    return $resultsFilePath
}