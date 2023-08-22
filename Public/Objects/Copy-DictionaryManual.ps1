function Copy-DictionaryManual {
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