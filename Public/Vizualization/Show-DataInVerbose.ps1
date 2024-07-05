function Show-DataInVerbose {
    <#
    .SYNOPSIS
    Displays the properties of an object in a verbose manner.

    .DESCRIPTION
    This function takes an object as input and displays each property of the object in a verbose format.

    .PARAMETER Object
    Specifies the object whose properties will be displayed.

    .EXAMPLE
    $data = [PSCustomObject]@{
        Name = "John Doe"
        Age = 30
        City = "New York"
    }
    Show-DataInVerbose -Object $data

    Description:
    Displays the properties of the $data object in a verbose manner.

    #>
    [CmdletBinding()]
    param(
        [Object] $Object
    )
    foreach ($O in $Object) {
        foreach ($E in $O.PSObject.Properties) {
            $FieldName = $E.Name
            $FieldValue = $E.Value
            Write-Verbose "Display-DataInVerbose - FieldName: $FieldName FieldValue: $FieldValue"
        }
    }
}
