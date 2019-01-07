function Convert-TimeToDays {
    [CmdletBinding()]
    param (
        $StartTime,
        $EndTime,
        #[nullable[DateTime]] $StartTime,
        #[nullable[DateTime]] $EndTime,
        [string] $Ignore = '*1601*'
    )
    <# Due to some use of string as StartTime in some code temporary using this version.
    Get-ObjectType -Object $StartTime -VerboseOnly -Verbose
    Get-ObjectType -Object $EndTime -VerboseOnly -Verbose
    #>
    if ($StartTime -and $EndTime) {
        try {
            if ($StartTime -notlike $Ignore -and $EndTime -notlike $Ignore) {
                $Days = (NEW-TIMESPAN -Start (GET-DATE) -End ($EndTime)).Days
            } else {
                $Days = $null
            }
        } catch {
            $Days = $null
        }
    }
    return $Days
}