# DAY 4

$day4input = @(Get-Content -Path C:\Temp\AdventOfCode\2018\Input-DAY4.txt)

$timeBook = @{}
$timeBookSorted = [ordered]@{}
$guardData = @{}
$guardHighestSleepTime = 0
$occurence = 0
[System.Collections.Generic.HashSet[DateTime]]$dateConversion = @{}

$day4input | ForEach-Object {
    $timeBook.Add((Get-Date "$($_.SubString(1,16))" -Format "yyyy-MM-dd hh:mm tt"),$_.Split('^]')[-1].trimstart().trimend())
}

$timeBook.Keys | Sort-Object | ForEach-Object {
    $timeBookSorted.Add($_,$timeBook[$_])
}

foreach ($timeSlot in $timeBookSorted.Keys) {
    
    if ($timeBookSorted."$timeSlot" -match 'Guard') {
        $guardID = [int]($timeBookSorted."$timeSlot").Split('^#').TrimEnd().Split(' ')[1]
        #Write-Host "GUARD ID: $guardID" -ForegroundColor Green
    }

    if (!$guardData.ContainsKey($guardID)) {
        #Write-Host "Create new set for GUARD ID: $guardID" -ForegroundColor Green
        $GD = @{
            recurrenceTime = @()
            fallsAsleep = @()
            wakesUp = @()
            sleepDuration = @()
            timeAsleep = 0
        }
        $guardData.Add($guardID,$GD)
    }

    switch (($timeBookSorted."$timeSlot")) {
        'falls asleep' { 
            $guardData[$guardID].fallsAsleep += (Get-Date $timeSlot -Format hh:mmtt)
            $guardData[$guardID].sleepDuration += (Get-Date $timeSlot).Minute
        }
        'wakes up' { 
            $guardData[$guardID].wakesUp += (Get-Date $timeSlot -Format hh:mmtt).Minute
            $diff = (Get-Date(Get-Date $timeSlot)).Minute - (Get-Date $guardData[$guardID].sleepDuration[-1]).Minute
            for ($x = 1;$x -lt $diff;$x++) {
                $guardData[$guardID].sleepDuration += (Get-Date(Get-Date $guardData[$guardID].sleepDuration[-1]).AddMinutes(1) -Format hh:mmtt).Minute
            }
            $guardData[$guardID].sleepDuration += (Get-Date(Get-Date $timeSlot).AddMinutes(-1) -Format hh:mmtt).Minute
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
    ($guardData[$key].sleepDuration | Group-Object | Select-Object count,name) | Where-Object { $_.count -gt 1 } | ForEach-Object {
        $guardData[$key].recurrenceTime += "$($_.count)@$($_.name)"
    }
}

$guardIDHighestSleepTime
$guardData[$guardIDHighestSleepTime].timeAsleep
$guardData[$guardIDHighestSleepTime].recurrenceTime | ForEach-Object {
    if ($occurence -lt [int]$_.Split('@')[0]) {
        $occurence = [int]$_.Split('@')[0]
    }
}
$guardData[$guardIDHighestSleepTime].recurrenceTime | Where-Object {
    $_ -match "^$occurence@"
}


#($guardData[877].fallsAsleep | Group-Object | Select-Object count,name).where({$_.Count -gt 1}) | %{ $_.Count;$_.Name;pause }