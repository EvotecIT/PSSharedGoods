function Get-ObjectProperties {
    param (
        [object] $Object
    )
    $Properties = New-ArrayList
    foreach ($O in $Object) {
        $ObjectProperties = $O.PSObject.Properties.Name
        foreach ($Property in $ObjectProperties) {
            Add-ToArrayAdvanced -List $Properties -Element $Property -SkipNull -RequireUnique
        }
    }
    return $Properties | Sort-Object
}