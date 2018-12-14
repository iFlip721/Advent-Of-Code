# DAY 3

$day3input = @(Get-Content -Path C:\Temp\AdventOfCode\2018\Input-DAY3.txt)

function Show-TheFabricOfOurLives {
    Remove-Item C:\Temp\fabric.txt -Force -Confirm:$false
    foreach ($key in $fabric.Keys | Sort-Object) {
        $fabric[$key] | Out-File C:\Temp\fabric.txt -Append -NoNewline
        "`n" | Out-File C:\Temp\fabric.txt -Append
    }
    C:\temp\fabric.txt
}

$requestData = @{}
$fabric      = [ordered]@{}
$highX = 0
$highY = 0
$fabricOverlap = 0

$day3input | ForEach-Object {
    $key = [int]($_ -split '@').replace('#','')[0].TrimStart().TrimEnd()
    $value = ($_ -split '@').replace(': ',',').replace('x',',')[1].TrimStart()
    $requestData.Add($key,$value)
}

foreach ($key in $requestData.Keys) {
    if ($highX -lt [int]$requestData[$key].Split(',')[0] + [int]$requestData[$key].Split(',')[2]) {
        $highX = [int]$requestData[$key].Split(',')[0] + [int]$requestData[$key].Split(',')[2]
        #Write-Host "X QUAD: $([int]$requestData[$key].Split(',')[0])" + "$([int]$requestData[$key].Split(',')[2])" -ForegroundColor Green
    }
    if ($highY -lt [int]$requestData[$key].Split(',')[1] + [int]$requestData[$key].Split(',')[3]) {
        $highY = [int]$requestData[$key].Split(',')[1] + [int]$requestData[$key].Split(',')[3]
        #Write-Host "Y QUAD: $([int]$requestData[$key].Split(',')[1])" + "$([int]$requestData[$key].Split(',')[3])" -ForegroundColor Magenta
    }
}


0..$highY | ForEach-Object {
    [int]$y = $_
    $fabricArrayInit = [string[]]::new($highX + 1)
    for ($i = 0;$i -lt $fabricArrayInit.GetUpperBound(0);$i++) {
        $fabricArrayInit[$i] = '∙'
    }
    $fabric.Add($y,$fabricArrayInit)
}


#1 @ 185,501: 17x15
#     0   1    2  3

# Hastable Legend
# 0 = Y
# 1 = X
# 2 = Length
# 3 = Height

# Multi-Dimensional Legend
# [X, 0] = Latitudinal Movement  (LAT,  NORTH-SOUTH)
# [0, Y] = Longitudinal Movement (LONG, EAST-WEST)


foreach ($key in $requestData.Keys) {
    
    $xValueStart = [int]$requestData[$key].Split(',')[0]
    $xValueStop  = [int]$requestData[$key].Split(',')[0] + [int]$requestData[$key].Split(',')[2]

    $yValueStart = [int]$requestData[$key].Split(',')[1]
    $yValueStop  = [int]$requestData[$key].Split(',')[1] + [int]$requestData[$key].Split(',')[3]
    
    for ($x = $xValueStart;$x -lt $xValueStop;$x++) {
        for ($y = $yValueStart;$y -lt $yValueStop;$y++) {
            if ('∙' -eq $fabric[$x][$y]) {
                $fabric[$x][$y] = '▒'
            } elseif ('▒' -eq $fabric[$x][$y]) {
                $fabric[$x][$y] = '█'
                $fabricOverlap++
            } else {
                $fabric[$x][$y] = '█'
            }
        }
    }

}
Write-Host "DAY 3 PART 1: " -NoNewline -ForegroundColor Magenta
Write-Host "$fabricOverlap" -ForegroundColor Green

foreach ($key in $requestData.Keys) {
    
    $overlapDetect = $false
    
    $xValueStart = [int]$requestData[$key].Split(',')[0]
    $xValueStop  = [int]$requestData[$key].Split(',')[0] + [int]$requestData[$key].Split(',')[2]

    $yValueStart = [int]$requestData[$key].Split(',')[1]
    $yValueStop  = [int]$requestData[$key].Split(',')[1] + [int]$requestData[$key].Split(',')[3]
    
    for ($x = $xValueStart;$x -lt $xValueStop;$x++) {
        for ($y = $yValueStart;$y -lt $yValueStop;$y++) {
            if ('█' -eq $fabric[$x][$y]) {
                $overlapDetect = $true
            }
        }
    }
    if (!$overlapDetect) {
        Write-Host "DAY 3 PART 2: " -NoNewline -ForegroundColor Magenta
        Write-Host "$key" -ForegroundColor Green
    }
}

#Show-TheFabricOfOurLives
