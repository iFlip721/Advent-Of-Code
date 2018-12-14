# DAY 1

$day1input = @(Get-Content -Path C:\Temp\AdventOfCode\2018\Input-DAY1.txt)

[System.Collections.Generic.HashSet[int]]$Primary = @{}
[int]$iteration = 0
[int]$currentFrequency = 0
[switch]$isDuplicate = $false

while (!$isDuplicate) {
    $iteration++
    ForEach ($frequencyChange in $day1input) {
        $currentFrequency = $currentFrequency + [int]$frequencyChange
        if (!$isDuplicate) {
            if (!$Primary.Add($currentFrequency)) {
                Write-Host "DAY 1 PART 2: " -NoNewline -ForegroundColor Magenta
                Write-Host "$currentFrequency" -ForegroundColor Green
                $isDuplicate = $true
            }
        }
    }
    if ($iteration -eq 1) {
        Write-Host "DAY 1 PART 1: " -NoNewline -ForegroundColor Magenta
        Write-Host "$currentFrequency" -ForegroundColor Green
    }
}