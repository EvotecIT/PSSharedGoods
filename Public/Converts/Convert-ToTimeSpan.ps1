function Convert-ToTimeSpan {
    <#
    .SYNOPSIS
    Calculates the time span between two given DateTime values.

    .DESCRIPTION
    This function calculates the time span between two specified DateTime values. It takes a start time and an end time as input parameters and returns the TimeSpan object representing the duration between them.

    .PARAMETER StartTime
    Specifies the start DateTime value. If not provided, the current date and time will be used as the default.

    .PARAMETER EndTime
    Specifies the end DateTime value.

    .EXAMPLE
    Convert-ToTimeSpan -StartTime (Get-Date).AddDays(-5) -EndTime (Get-Date)
    # Calculates the time span between 5 days ago and today.

    .EXAMPLE
    Convert-ToTimeSpan -StartTime '2022-01-01' -EndTime '2022-01-10'
    # Calculates the time span between January 1, 2022, and January 10, 2022.

    #>
    [CmdletBinding()]
    param (
        [DateTime] $StartTime = (Get-Date),
        [DateTime] $EndTime
    )
    if ($StartTime -and $EndTime) {
        try {
            $TimeSpan = (New-TimeSpan -Start $StartTime -End $EndTime)
        } catch {
            $TimeSpan = $null
        }
    }
    if ($null -ne $TimeSpan) {
        return $TimeSpan
    } else {
        return $null
    }
}