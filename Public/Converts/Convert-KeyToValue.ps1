function Convert-KeyToKeyValue {
    <#
    .SYNOPSIS
    Converts keys of an object to key-value pairs.

    .DESCRIPTION
    This function takes an object and converts its keys to key-value pairs, where the key is the original key concatenated with its corresponding value.

    .PARAMETER Object
    Specifies the object whose keys are to be converted to key-value pairs.

    .EXAMPLE
    $Object = @{
        Key1 = 'Value1'
        Key2 = 'Value2'
    }
    Convert-KeyToKeyValue -Object $Object
    # Returns a new hash table with keys as 'Key1 (Value1)' and 'Key2 (Value2)'.

    #>
    [CmdletBinding()]
    param (
        [object] $Object
    )
    $NewHash = [ordered] @{}
    foreach ($O in $Object.Keys) {
        $KeyName = "$O ($($Object.$O))"
        $KeyValue = $Object.$O
        $NewHash.$KeyName = $KeyValue
    }
    return $NewHash
}