Function Get-Types {
    <#
    .SYNOPSIS
    Retrieves the enum values of the specified types.

    .DESCRIPTION
    This function takes an array of types and returns the enum values of each type.

    .PARAMETER Types
    Specifies the types for which enum values need to be retrieved.

    .EXAMPLE
    Get-Types -Types [System.DayOfWeek]
    Retrieves the enum values of the System.DayOfWeek type.

    .EXAMPLE
    Get-Types -Types [System.ConsoleColor, System.EnvironmentVariableTarget]
    Retrieves the enum values of the System.ConsoleColor and System.EnvironmentVariableTarget types.
    #>
    [CmdletBinding()]
    param (
        [Object] $Types
    )
    $TypesRequired = foreach ($Type in $Types) {
        $Type.GetEnumValues()
    }
    return $TypesRequired
}