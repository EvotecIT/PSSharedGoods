function Convert-ToDateTime {
    [CmdletBinding()]
    param (
        [string] $Timestring,
        [string] $Ignore = '*1601*'
    )
    Try {
        $DateTime = ([datetime]::FromFileTime($Timestring))
    } catch {
        $DateTime = $null
    }
    #Write-Verbose "Convert-ToDateTime: $DateTime"
    if ($DateTime -eq $null -or $DateTime -like $Ignore) {
        return $null
    } else {
        return $DateTime
    }
}