# DAY 5

$day5input = Get-Content -Path C:\Temp\AdventOfCode\2018\Input-DAY5.txt

$lastLoop = 0
$currentLoop = 0
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
    $currentLoop
} while ($lastLoop -ne $currentLoop)
