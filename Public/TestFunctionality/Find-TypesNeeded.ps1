function Find-TypesNeeded {
    <#
    .SYNOPSIS
    Finds if specific types are needed among the required types.

    .DESCRIPTION
    This function checks if any of the specified types in $TypesNeeded are among the required types in $TypesRequired. Returns $true if any type is found, otherwise $false.

    .PARAMETER TypesRequired
    Specifies an array of types that are required.

    .PARAMETER TypesNeeded
    Specifies an array of types to check if they are needed.

    .EXAMPLE
    Find-TypesNeeded -TypesRequired @('System.String', 'System.Int32') -TypesNeeded @('System.Int32')
    Checks if 'System.Int32' is among the required types 'System.String' and 'System.Int32'.

    .EXAMPLE
    Find-TypesNeeded -TypesRequired @('System.Management.Automation.PSCredential', 'System.Net.IPAddress') -TypesNeeded @('System.Net.IPAddress')
    Checks if 'System.Net.IPAddress' is needed among the required types 'System.Management.Automation.PSCredential' and 'System.Net.IPAddress'.
    #>
    [CmdletBinding()]
    param (
        [Array] $TypesRequired,
        [Array] $TypesNeeded
    )
    [bool] $Found = $False
    foreach ($Type in $TypesNeeded) {
        if ($TypesRequired -contains $Type) {
            $Found = $true
            break
        }
    }
    return $Found
}