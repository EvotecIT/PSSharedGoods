function Convert-GenericRightsToFileSystemRights {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER OriginalRights
    Parameter description

    .EXAMPLE
    An example

    .NOTES

    .LINK
    Improved https://blog.cjwdev.co.uk/2011/06/28/permissions-not-included-in-net-accessrule-filesystemrights-enum/

    #>
    [cmdletBinding()]
    param(
        [System.Security.AccessControl.FileSystemRights] $OriginalRights
    )
    Begin {
        $FileSystemRights = [System.Security.AccessControl.FileSystemRights]
        $GenericRights = @{
            GENERIC_READ    = 0x80000000;
            GENERIC_WRITE   = 0x40000000;
            GENERIC_EXECUTE = 0x20000000;
            GENERIC_ALL     = 0x10000000;
            FILTER_GENERIC  = 0x0FFFFFFF;
        }
        $MappedGenericRights = @{
            FILE_GENERIC_EXECUTE = $FileSystemRights::ExecuteFile -bor $FileSystemRights::ReadPermissions -bor $FileSystemRights::ReadAttributes -bor $FileSystemRights::Synchronize
            FILE_GENERIC_READ    = $FileSystemRights::ReadAttributes -bor $FileSystemRights::ReadData -bor $FileSystemRights::ReadExtendedAttributes -bor $FileSystemRights::ReadPermissions -bor $FileSystemRights::Synchronize
            FILE_GENERIC_WRITE   = $FileSystemRights::AppendData -bor $FileSystemRights::WriteAttributes -bor $FileSystemRights::WriteData -bor $FileSystemRights::WriteExtendedAttributes -bor $FileSystemRights::ReadPermissions -bor $FileSystemRights::Synchronize
            FILE_GENERIC_ALL     = $FileSystemRights::FullControl
        }
    }
    Process {
        $MappedRights = [System.Security.AccessControl.FileSystemRights]::new()
        if ($OriginalRights -band $GenericRights.GENERIC_EXECUTE) {
            $MappedRights = $MappedRights -bor $MappedGenericRights.FILE_GENERIC_EXECUTE
        }
        if ($OriginalRights -band $GenericRights.GENERIC_READ) {
            $MappedRights = $MappedRights -bor $MappedGenericRights.FILE_GENERIC_READ
        }
        if ($OriginalRights -band $GenericRights.GENERIC_WRITE) {
            $MappedRights = $MappedRights -bor $MappedGenericRights.FILE_GENERIC_WRITE
        }
        if ($OriginalRights -band $GenericRights.GENERIC_ALL) {
            $MappedRights = $MappedRights -bor $MappedGenericRights.FILE_GENERIC_ALL
        }
        (($OriginalRights -bAND $GenericRights.FILTER_GENERIC) -bOR $MappedRights) -as $FileSystemRights
    }
    End {

    }
}