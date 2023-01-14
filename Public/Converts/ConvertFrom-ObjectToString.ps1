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
        [ValidateSet('Hashtable', 'Ordered', 'PSCustomObject')][string] $OutputType = 'Hashtable'

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
                    Write-Host -Object "    '$Key' = '$($Object.$Key)'" -ForegroundColor Cyan
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
                    Write-Host -Object "    '$Key' = '$($Object.$Key)'" -ForegroundColor Cyan
                }
                Write-Host -Object "}"
            } else {
                Write-Host -Object $Object
            }
        }

    }
}