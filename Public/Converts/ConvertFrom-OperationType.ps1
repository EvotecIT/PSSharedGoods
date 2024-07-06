Function ConvertFrom-OperationType {
    <#
    .SYNOPSIS
    Converts operation type codes to human-readable descriptions.

    .DESCRIPTION
    This function takes an operation type code and returns the corresponding human-readable description.

    .PARAMETER OperationType
    The operation type code to be converted.

    .EXAMPLE
    ConvertFrom-OperationType -OperationType '%%14674'
    Output: 'Value Added'

    .EXAMPLE
    ConvertFrom-OperationType -OperationType '%%14675'
    Output: 'Value Deleted'

    .EXAMPLE
    ConvertFrom-OperationType -OperationType '%%14676'
    Output: 'Unknown'
    #>
    param (
        [string] $OperationType
    )
    $Known = @{
        '%%14674' = 'Value Added'
        '%%14675' = 'Value Deleted'
        '%%14676' = 'Unknown'
    }
    foreach ($id in $OperationType) {
        if ($name = $Known[$id]) { return $name }
    }
    return $OperationType
}