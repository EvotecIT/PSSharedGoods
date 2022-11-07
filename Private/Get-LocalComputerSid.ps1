function Get-LocalComputerSid {
    <#
    .SYNOPSIS
    Get the SID of the local computer.

    .DESCRIPTION
    Get the SID of the local computer.

    .EXAMPLE
    Get-LocalComputerSid

    .NOTES
    General notes
    #>
    [cmdletBinding()]
    param()
    try {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        $PrincipalContext = [System.DirectoryServices.AccountManagement.PrincipalContext]::new([System.DirectoryServices.AccountManagement.ContextType]::Machine)
        $UserPrincipal = [System.DirectoryServices.AccountManagement.UserPrincipal]::new($PrincipalContext)
        $Searcher = [System.DirectoryServices.AccountManagement.PrincipalSearcher]::new()
        $Searcher.QueryFilter = $UserPrincipal
        $User = $Searcher.FindAll()
        foreach ($U in $User) {
            if ($U.Sid.Value -like "*-500") {
                return $U.Sid.Value.TrimEnd("-500")
            }
        }
    } catch {
        Write-Warning -Message "Get-LocalComputerSid - Error: $($_.Exception.Message)"
    }
}