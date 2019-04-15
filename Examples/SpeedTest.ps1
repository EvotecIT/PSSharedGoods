# Helper function
function Measure-Collection {
    param(
        [string] $Name,
        [ScriptBlock] $ScriptBlock
    )
    $Time = [System.Diagnostics.Stopwatch]::StartNew()
    $Output = Invoke-Command -ScriptBlock $ScriptBlock
    $Time.Stop()
    "Name: $Name, Elements: $Output - $($Time.Elapsed.Days) days, $($Time.Elapsed.Hours) hours, $($Time.Elapsed.Minutes) minutes, $($Time.Elapsed.Seconds) seconds, $($Time.Elapsed.Milliseconds) milliseconds, ticks $($Time.Elapsed.Ticks)"
}

# Gather data for testing
if ($null -eq $Files) {
    # get large data sets
    $Files = Get-ChildItem -Path 'C:\' -File -Recurse -ErrorAction SilentlyContinue
    $Files.Count
}


Measure-Collection -Name 'Where-Object but not full name' {
    $LargeFiles = $Files | Where { $_.Length -gt 1MB }
    $LargeFiles.Count
}


Measure-Collection -Name 'Where-Object' {
    $LargeFiles = $Files | Where-Object { $_.Length -gt 1MB }
    $LargeFiles.Count
}

Measure-Collection -Name 'ForEach-Object but without full name' {
    $LargeFiles = $Files | ForEach {
        if ($_.Length -gt 1MB) {
            $_
        }
    }
    $LargeFiles.Count
}

Measure-Collection -Name 'ForEach-Object' {
    $LargeFiles = $Files | ForEach-Object {
        if ($_.Length -gt 1MB) {
            $_
        }
    }
    $LargeFiles.Count
}

Measure-Collection -Name 'Process' {
    $LargeFiles = $Files | & {
        process {
            if ($_.Length -gt 1MB)
            { $_ }
        }
    }
    $LargeFiles.Count
}
Measure-Collection -Name 'ForEach' {
    $LargeFiles = ForEach ($_ in $Files) {
        if ($_.Length -gt 1MB) {
            $_
        }
    }
    $LargeFiles.Count
}
Measure-Collection -Name 'ForEach With Named Variable' {
    $LargeFiles = ForEach ($F in $Files) {
        if ($F.Length -gt 1MB) {
            $F
        }
    }
    $LargeFiles.Count
}

Measure-Collection -Name 'For Loop' {
    $LargeFiles = For ($i = 0; $i -le $Files.Count; $i++) {
        if ($Files[$i].Length -gt 1MB) {
            $Files[$i]
        }
    }
    $LargeFiles.Count
}