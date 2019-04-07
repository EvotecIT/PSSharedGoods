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
    if ($null -eq $DateTime -or $DateTime -like $Ignore) {
        return $null
    } else {
        return $DateTime
    }
}