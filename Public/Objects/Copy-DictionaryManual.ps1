function Copy-DictionaryManual {
    <#
    .SYNOPSIS
    Copies a dictionary recursively, handling nested dictionaries and lists.

    .DESCRIPTION
    This function copies a dictionary recursively, handling nested dictionaries and lists. It creates a deep copy of the input dictionary, ensuring that modifications to the copied dictionary do not affect the original dictionary.

    .PARAMETER Dictionary
    The dictionary to be copied.

    .EXAMPLE
    $originalDictionary = @{
        'Key1' = 'Value1'
        'Key2' = @{
            'NestedKey1' = 'NestedValue1'
        }
    }
    $copiedDictionary = Copy-DictionaryManual -Dictionary $originalDictionary

    This example demonstrates how to copy a dictionary with nested values.

    #>
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Dictionary
    )

    $clone = [ordered] @{}
    foreach ($Key in $Dictionary.Keys) {
        $value = $Dictionary.$Key

        $clonedValue = switch ($Dictionary.$Key) {
            { $null -eq $_ } {
                $null
                continue
            }
            { $_ -is [System.Collections.IDictionary] } {
                Copy-DictionaryManual -Dictionary $_
                continue
            }
            {
                $type = $_.GetType()
                $type.IsPrimitive -or $type.IsValueType -or $_ -is [string]
            } {
                $_
                continue
            }
            default {
                $_ | Select-Object -Property *
            }

        }

        if ($value -is [System.Collections.IList]) {
            $clone[$Key] = @($clonedValue)
        } else {
            $clone[$Key] = $clonedValue
        }
    }

    $clone
}