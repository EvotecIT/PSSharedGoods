function Format-PSTableConvertType3 {
    [CmdletBinding()]
    param (
        $Object,
        [switch] $SkipTitles,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        [bool] $OverwriteHeaders
    )
    #Write-Verbose 'Format-PSTableConvertType3 - Option 3'
    $Array = New-ArrayList
    ### Add Titles
    if (-not $SkipTitles) {
        $Titles = New-ArrayList
        Add-ToArray -List $Titles -Element 'Name'
        Add-ToArray -List $Titles -Element 'Value'
        Add-ToArray -List $Array -Element $Titles
    }
    ### Add Data
    foreach ($O in $Object) {
        foreach ($Name in $O.Keys) {
            # Write-Verbose "Test2 - $Key - $($O[$Key])"
            $ArrayValues = New-ArrayList
            if ($ExcludeProperty -notcontains $Name) {
                Add-ToArray -List $ArrayValues -Element $Name
                Add-ToArray -List $ArrayValues -Element $O[$Name]
                Add-ToArray -List $Array -Element $ArrayValues
            }
        }
    }
    return , $Array
}