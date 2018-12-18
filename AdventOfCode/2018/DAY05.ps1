# DAY 5

$day5input = Get-Content -Path C:\Temp\AdventOfCode\2018\Input-DAY5.txt

$lastLoop = 0
$currentLoop = 0
$highPolymerUpperCount = 0
$highPolymerLowerCount = 0
$char = 65

do {
    $lastLoop = $currentLoop
    for($charIncrement = 0;$charIncrement -lt 26;$charIncrement++) {
        $upperChar = [char]($char + $charIncrement)
        $lowerChar = [char]($char + 32 + $charIncrement)
        $day5input = $day5input.Replace("$lowerChar$upperChar",'')
        $day5input = $day5input.Replace("$upperChar$lowerChar",'')
    }
    $currentLoop = $day5input.Length
} while ($lastLoop -ne $currentLoop)

Write-Host "DAY 5 PART 1: " -NoNewline -ForegroundColor Magenta
Write-Host "Fully reacting Polymer = $currentLoop" -ForegroundColor Green

$lastLoop = 0
$currentLoop = 0
$lowestReactivePolymer = $day5input.Length
$char = 65

for($charIncrementParent = 0;$charIncrementParent -lt 26;$charIncrementParent++) {
    
    $day5input = Get-Content -Path C:\Temp\AdventOfCode\2018\Input-DAY5.txt
    $upperCharParent = [char]($char + $charIncrementParent)
    $lowerCharParent = [char]($char + 32 + $charIncrementParent)
    $day5input = $day5input.Replace("$upperCharParent",'')
    $day5input = $day5input.Replace("$lowerCharParent",'')

    do {
        $lastLoop = $currentLoop
        for($charIncrementChild = 0;$charIncrementChild -lt 26;$charIncrementChild++) {
            $upperCharChild = [char]($char + $charIncrementChild)
            $lowerCharChild = [char]($char + 32 + $charIncrementChild)
            $day5input = $day5input.Replace("$lowerCharChild$upperCharChild",'')
            $day5input = $day5input.Replace("$upperCharChild$lowerCharChild",'')
        }
        $currentLoop = $day5input.Length
    } while ($lastLoop -ne $currentLoop)
    
    if ($lowestReactivePolymer -gt $currentLoop) {
        $lowestReactivePolymer = $currentLoop
        $lowestReactivePolymerChar = $upperCharParent
    }
}

Write-Host "DAY 5 PART 1: " -NoNewline -ForegroundColor Magenta
Write-Host "Shortest Polymer = $lowestReactivePolymer" -ForegroundColor Green