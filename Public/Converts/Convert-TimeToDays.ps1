function Convert-TimeToDays {
    <#
    .SYNOPSIS
    Converts the time span between two dates into the number of days.

    .DESCRIPTION
    This function calculates the number of days between two given dates. It allows for flexibility in handling different date formats and provides an option to ignore specific dates.

    .PARAMETER StartTime
    Specifies the start date and time of the time span.

    .PARAMETER EndTime
    Specifies the end date and time of the time span.

    .PARAMETER Ignore
    Specifies a pattern to ignore specific dates. Default is '*1601*'.

    .EXAMPLE
    Convert-TimeToDays -StartTime (Get-Date).AddDays(-5) -EndTime (Get-Date)
    # Calculates the number of days between 5 days ago and today.

    .EXAMPLE
    Convert-TimeToDays -StartTime '2022-01-01' -EndTime '2022-01-10' -Ignore '*2022*'
    # Calculates the number of days between January 1, 2022, and January 10, 2022, ignoring any dates containing '2022'.

    #>
    [CmdletBinding()]
    param (
        $StartTime,
        $EndTime,
        #[nullable[DateTime]] $StartTime, # can't use this just yet, some old code uses strings in StartTime/EndTime.
        #[nullable[DateTime]] $EndTime, # After that's fixed will change this.
        [string] $Ignore = '*1601*'
    )
    if ($null -ne $StartTime -and $null -ne $EndTime) {
        try {
            if ($StartTime -notlike $Ignore -and $EndTime -notlike $Ignore) {
                $Days = (NEW-TIMESPAN -Start $StartTime -End $EndTime).Days
            }
        } catch {}
    } elseif ($null -ne $EndTime) {
        if ($StartTime -notlike $Ignore -and $EndTime -notlike $Ignore) {
            $Days = (NEW-TIMESPAN -Start (Get-Date) -End ($EndTime)).Days
        }
    } elseif ($null -ne $StartTime) {
        if ($StartTime -notlike $Ignore -and $EndTime -notlike $Ignore) {
            $Days = (NEW-TIMESPAN -Start $StartTime -End (Get-Date)).Days
        }
    }
    return $Days
}