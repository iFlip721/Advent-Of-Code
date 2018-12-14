# DAY 2

# 2, 3 = one(2) one(3)
# 2, 0 = one(2)
# 0, 3 = one(3)
# 2, 2 = one(2)
# 2, 0 = one(2)
# 3, 3 = one(3)

$day2input = @(Get-Content -Path C:\Temp\AdventOfCode\2018\Input-DAY2.txt)
$checksumEquates = @(0,0)

ForEach ($checksum in $day2input) {  
     
    $group = [char[]]$checksum | Group-Object

    if ($group.GetEnumerator().Count -contains 2) {
        $checksumEquates[0]++
    } 
    if ($group.GetEnumerator().Count -contains 3) {
        $checksumEquates[1]++
    }

}

Write-Host "DAY 2 PART 1: " -NoNewline -ForegroundColor Magenta
Write-Host "$($checksumEquates[0] *$checksumEquates[1])" -ForegroundColor Green


$x = 0
$y = 0
foreach ($charLoop in [char[]]$checksum) {
    [System.Collections.Generic.HashSet[string]]$checksumDifferential = @{}
    $y++
    $day2input | ForEach-Object {
        if (!$checksumDifferential.Add("$($_.SubString(0,$x))"+','+"$($_.SubString($y,$checksum.Length-$y))")) {
            Write-Host "DAY 2 PART 2: " -NoNewline -ForegroundColor Magenta
            Write-Host "$($_.SubString(0,$x))$($_.SubString($y,$checksum.Length-$y))" -ForegroundColor Green
        }
    }
    $x++
}