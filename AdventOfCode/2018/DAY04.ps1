# DAY 4

$day4input = @(Get-Content -Path C:\Temp\AdventOfCode\2018\Input-DAY4.txt | Sort-Object)

$timeBook =[ordered] @{}
$guardData = @{}
$occurence = 0
$highRecrurrence = @(0,0,0)
[System.Collections.Generic.HashSet[DateTime]]$dateConversion = @{}

$day4input | ForEach-Object {
    $timeBook.Add((Get-Date "$($_.SubString(1,16))" -Format "yyyy-MM-dd hh:mm tt"),$_.Split('^]')[-1].trimstart().trimend())
}

foreach ($timeSlot in $timeBook.Keys) {
    
    if ($timeBook."$timeSlot" -match 'Guard') {
        $guardID = [int]($timeBook."$timeSlot").Split('^#').TrimEnd().Split(' ')[1]
    }

    if (!$guardData.ContainsKey($guardID)) {
        $GD = @{
            recurrenceTime = @()
            fallsAsleep = @()
            wakesUp = @()
            sleepDuration = @()
            minute = @()
            timeAsleep = 0
        }
        $guardData.Add($guardID,$GD)
    }

    switch (($timeBook."$timeSlot")) {
        'falls asleep' { 
            $guardData[$guardID].fallsAsleep += (Get-Date $timeSlot -Format hh:mmtt)
            $guardData[$guardID].sleepDuration += (Get-Date $timeSlot -Format hh:mmtt)
            $guardData[$guardID].minute += (Get-Date $timeSlot).Minute
        }
        'wakes up' { 
            $guardData[$guardID].wakesUp += (Get-Date $timeSlot -Format hh:mmtt)
            $diff = (Get-Date(Get-Date $timeSlot)).Minute - (Get-Date $guardData[$guardID].sleepDuration[-1]).Minute
            for ($x = 1;$x -lt $diff;$x++) {
                $guardData[$guardID].minute += (Get-Date(Get-Date $guardData[$guardID].sleepDuration[-1]).AddMinutes(1)).Minute
                $guardData[$guardID].sleepDuration += (Get-Date(Get-Date $guardData[$guardID].sleepDuration[-1]).AddMinutes(1) -Format hh:mmtt)
            }
            [int]$lastFallsAsleep = (Get-Date $guardData[$guardID].fallsAsleep[-1] -Format mm)
            $guardData[$guardID].timeAsleep += [int](Get-Date $timeSlot).AddMinutes(-$lastFallsAsleep).Minute
        }
        default { [void]$null }
    }

}

foreach ($key in $guardData.Keys) {
    
    if ($guardHighestSleepTime -lt [int]$guardData[$key].timeAsleep) {
        $guardIDHighestSleepTime = $key
        $guardHighestSleepTime = [int]$guardData[$key].timeAsleep
    }
    ($guardData[$key].minute | Group-Object | Select-Object count,name) | Where-Object { $_.count -gt 1 } | ForEach-Object {
        $guardData[$key].recurrenceTime += "$($_.count)@$($_.name)"
    }

}

#$guardIDHighestSleepTime
#$guardData[$guardIDHighestSleepTime].timeAsleep
$guardData[$guardIDHighestSleepTime].recurrenceTime | ForEach-Object {
    if ($occurence -lt [int]$_.Split('@')[0]) {
        $occurence = [int]$_.Split('@')[0]
        $minute = [int]$_.Split('@')[1]
    }
}

$occurenceTop = 0
$occurenceTopMin = 0
foreach ($key in $guardData.Keys) {
    foreach ($recurrence in $guardData[$key].recurrenceTime) {
        if ($occurenceTop -lt [int]$recurrence.Split('@')[0]) {
            $occurenceTop = [int]$recurrence.Split('@')[0]
            $occurenceTopMin = [int]$recurrence.Split('@')[1]
            $guardTop = $key
            #$minute = [int]$_.recurrenceTime.Split('@')[1]
        }
    }
    
}
Write-Host "DAY 4 PART 1: " -NoNewline -ForegroundColor Magenta
Write-Host "Guard ID: $guardIDHighestSleepTime, Minute: $minute = $($guardIDHighestSleepTime * $minute)" -ForegroundColor Green

Write-Host "DAY 4 PART 2: " -NoNewline -ForegroundColor Magenta
Write-Host "Guard ID: $guardTop, Minute: $occurenceTopMin = $($guardTop * $occurenceTopMin)" -ForegroundColor Green