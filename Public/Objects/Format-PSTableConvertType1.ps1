function Format-PSTableConvertType1 {
    [CmdletBinding()]
    param (
        [Object] $Object,
        [switch] $SkipTitles,
        [string[]] $Property,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        [Object] $OverwriteHeaders # not used - requires fix
    )
    #Write-Verbose 'Format-PSTableConvertType1 - Option 1'
    $Array = New-ArrayList
    ### Add Titles
    if (-not $SkipTitles) {
        $Titles = New-ArrayList
        Add-ToArray -List $Titles -Element 'Name'
        Add-ToArray -List $Titles -Element 'Value'
        Add-ToArray -List $Array -Element $Titles
    }
    ### Add Data
    foreach ($Name in $Object.Keys) {
        Write-Verbose "$Name"
        Write-Verbose "$Object.$Name"
        $ArrayValues = New-ArrayList
        if ($Property) {
            if ($Property -contains $Name) {
                Add-ToArray -List $ArrayValues -Element $Name
                Add-ToArray -List $ArrayValues -Element $Object.$Name
                Add-ToArray -List $Array -Element $ArrayValues
            }
        } else {
            if (-not $ExcludeProperty -notcontains $Name) {
                Add-ToArray -List $ArrayValues -Element $Name
                Add-ToArray -List $ArrayValues -Element $Object.$Name
                Add-ToArray -List $Array -Element $ArrayValues
            }
        }
    }
    return , $Array
}