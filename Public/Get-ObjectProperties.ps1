
# This function goes thru an object such as Get-Aduser and scans every object returned getting all properties
# This basically makes sure that all properties are known at run time of Export to SQL, Excel or Word
function Get-ObjectProperties {
    param (
        [object] $Object,
        [string[]] $AddProperties # provides ability to add some custom properties
    )
    $Properties = New-ArrayList
    foreach ($O in $Object) {
        $ObjectProperties = $O.PSObject.Properties.Name
        foreach ($Property in $ObjectProperties) {
            Add-ToArrayAdvanced -List $Properties -Element $Property -SkipNull -RequireUnique
        }
    }
    foreach ($Property in $AddProperties) {
        Add-ToArrayAdvanced -List $Properties -Element $Property -SkipNull -RequireUnique
    }
    return $Properties | Sort-Object
}