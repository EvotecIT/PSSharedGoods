
# This function goes thru an object such as Get-Aduser and scans every object returned getting all properties
# This basically makes sure that all properties are known at run time of Export to SQL, Excel or Word

<#
$Test = Get-Process

Get-ObjectProperties -Object $Test
#>
function Get-ObjectProperties {
    param (
        [object] $Object,
        [string[]] $AddProperties, # provides ability to add some custom properties
        [switch] $Sort,
        [bool] $RequireUnique = $true
    )
    $Properties = @(
        foreach ($O in $Object) {
            $ObjectProperties = $O.PSObject.Properties.Name
            $ObjectProperties
            # foreach ($Property in $ObjectProperties) {
            #     $Property
            # }
        }
        foreach ($Property in $AddProperties) {
            #Add-ToArrayAdvanced -List $Properties -Element $Property -SkipNull -RequireUnique
            $Property
        }
    )
    if ($Sort) {
        return $Properties | Sort-Object -Unique:$RequireUnique
    } else {
        return $Properties | Select-Object -Unique:$RequireUnique
    }
}