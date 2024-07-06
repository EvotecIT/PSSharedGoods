function Convert-ToDateTime {
    <#
    .SYNOPSIS
    Converts a file time string to a DateTime object.

    .DESCRIPTION
    This function converts a file time string to a DateTime object. It handles the conversion and provides flexibility to ignore specific file time strings.

    .PARAMETER Timestring
    Specifies the file time string to convert to a DateTime object.

    .PARAMETER Ignore
    Specifies a pattern to ignore specific file time strings. Default is '*1601*'.

    .EXAMPLE
    Convert-ToDateTime -Timestring '132479040000000000'
    # Converts the file time string '132479040000000000' to a DateTime object.

    .EXAMPLE
    Convert-ToDateTime -Timestring '132479040000000000' -Ignore '*1601*'
    # Converts the file time string '132479040000000000' to a DateTime object, ignoring any file time strings containing '1601'.

    #>
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
    if ($null -eq $DateTime -or $Timestring -like $Ignore) {
        return $null
    } else {
        return $DateTime
    }
}