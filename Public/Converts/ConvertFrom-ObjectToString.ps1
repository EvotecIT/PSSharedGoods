function ConvertFrom-ObjectToString {
    <#
    .SYNOPSIS
    Helps with converting given objects to their string representation.

    .DESCRIPTION
     Helps with converting given objects to their string representation.

    .PARAMETER Objects
    Objects to convert to string representation.

    .PARAMETER IncludeProperties
    Properties to include in the string representation.

    .PARAMETER ExcludeProperties
    Properties to exclude from the string representation.

    .PARAMETER OutputType
    Type of the output object. Options are: Hashtable, Ordered, PSCustomObject. If not specified, the output type is hashtable (string)

    .PARAMETER NumbersAsString
    If specified, numbers are converted to strings. Default is number are presented in their (unquoted) numerica form

    .PARAMETER QuotePropertyNames
    If specified, all property names are quoted. Default: property names are quoted only if they contain spaces.

    .PARAMETER DateTimeFormat
    Format for DateTime values. Default: 'yyyy-MM-dd HH:mm:ss'

    .EXAMPLE
    Get-Process -Name "PowerShell" | ConvertFrom-ObjectToString -IncludeProperties 'ProcessName', 'Id', 'Handles'

    OUTPUT:
    @{
        'Handles' = '543'
        'Id' = '8092'
        'ProcessName' = 'powershell'
    }

    @{
        'Handles' = '636'
        'Id' = '11360'
        'ProcessName' = 'powershell'
    }

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory)][Array] $Objects,
        [string[]] $IncludeProperties,
        [string[]] $ExcludeProperties,
        [ValidateSet('Hashtable', 'Ordered', 'PSCustomObject')][string] $OutputType = 'Hashtable',
        [switch] $NumbersAsString,
        [switch] $QuotePropertyNames,
        [string] $DateTimeFormat = 'yyyy-MM-dd HH:mm:ss'
    )
    begin {
        if ($OutputType -eq 'Hashtable') {
            $Type = ''
        } elseif ($OutputType -eq 'Ordered') {
            $Type = '[Ordered] '
        } else {
            $Type = '[PSCustomObject] '
        }
    }
    process {
        filter IsNumeric() {
            return $_ -is [byte] -or $_ -is [int16] -or $_ -is [int32] -or $_ -is [int64]  `
                -or $_ -is [sbyte] -or $_ -is [uint16] -or $_ -is [uint32] -or $_ -is [uint64] `
                -or $_ -is [float] -or $_ -is [double] -or $_ -is [decimal]
        }
        function GetFormattedPair () {
            # returns 'key' = <valuestring> or just <valuestring> if key is empty
            # valuestring is either $null, '<string>', or number
            param (
                [string] $Key,
                [object] $Value
            )
            if ($key -eq '') {
                $left = ''
            } elseif ($key -match '\s' -or $QuotePropertyNames) {
                $left = "'$Key' = "
            } else {
                $left = "$Key = "
            }
            if ($null -eq $value) {
                "$left`$null"
            } elseif ($Value -is [System.Collections.IList]) {
                $arrayStrings = foreach ($element in $Object.$Key) {
                    GetFormattedPair -Key '' -Value $element
                }
                "$left@(" + ($arrayStrings -join ', ') + ")"
            } elseif ($Value -is [System.Collections.IDictionary]) {
                if ($IncludeProperties -and $Key -notin $IncludeProperties) {
                    return
                }
                if ($Key -in $ExcludeProperties) {
                    return
                }
                $propertyString = foreach ($Key in $Value.Keys) {
                    GetFormattedPair -Key $key -Value $Value[$key]
                }
                "$left@{" + ($propertyString -join '; ') + "}"
            } elseif ($value -is [DateTime]) {
                "$left'$($Value.ToString($DateTimeFormat))'"
            } elseif (($value | IsNumeric) -and -not $NumbersAsString) {
                "$left$($Value)"
            } else {
                "$left'$($Value)'"
            }
        }

        foreach ($Object in $Objects) {
            if ($Object -is [System.Collections.IDictionary]) {
                Write-Host
                Write-Host -Object "$Type@{"
                foreach ($Key in $Object.Keys) {
                    if ($IncludeProperties -and $Key -notin $IncludeProperties) {
                        continue
                    }
                    if ($Key -in $ExcludeProperties) {
                        continue
                    }
                    Write-Host -Object "    $(GetFormattedPair -Key $Key -Value $Object.$Key)" -ForegroundColor Cyan
                }
                Write-Host -Object "}"
            } elseif ($Object -is [Object]) {
                Write-Host
                Write-Host -Object "$Type@{"
                foreach ($Key in $Object.PSObject.Properties.Name) {
                    if ($IncludeProperties -and $Key -notin $IncludeProperties) {
                        continue
                    }
                    if ($Key -in $ExcludeProperties) {
                        continue
                    }
                    Write-Host -Object "    $(GetFormattedPair -Key $Key -Value $Object.$Key)" -ForegroundColor Cyan
                }
                Write-Host -Object "}"
            } else {
                Write-Host -Object $Object
            }
        }

    }
}