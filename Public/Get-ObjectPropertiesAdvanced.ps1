function Get-ObjectPropertiesAdvanced {
    [CmdletBinding()]
    param (
        [object] $Object,
        [string[]] $AddProperties, # provides ability to add some custom properties
        [switch] $Sort
    )
    $Data = @{}
    $Properties = New-ArrayList
    $HighestCount = 0

    foreach ($O in $Object) {
        $ObjectProperties = $O.PSObject.Properties.Name
        $Test = $ObjectProperties -join ','
        $Count = $ObjectProperties.Count
        if ($Count -gt $HighestCount) {
            $Data.HighestCount = $Count
            $Data.HighestObject = $O
            $HighestCount = $Count
        }
        foreach ($Property in $ObjectProperties) {
            Add-ToArrayAdvanced -List $Properties -Element $Property -SkipNull -RequireUnique
        }
    }
    foreach ($Property in $AddProperties) {
        Add-ToArrayAdvanced -List $Properties -Element $Property -SkipNull -RequireUnique
    }
    $Data.Properties = if ($Sort) { $Properties | Sort-Object } else { $Properties }
    #Write-Verbose "Get-ObjectPropertiesAdvanced - HighestCount: $($Data.HighestCount)"
    #Write-Verbose "Get-ObjectPropertiesAdvanced - Properties: $($($Data.Properties) -join ',')"

    # returns for example
    # $Data.HighestCount = 100
    # $Data.HighestObject = $Object
    # $Data.Properties = array of strings
    return $Data
}