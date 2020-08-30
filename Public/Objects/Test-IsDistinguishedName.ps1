function Test-IsDistinguishedName {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Identity
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    Original source: https://github.com/PsCustomObject/IT-ToolBox/blob/master/Public/Test-IsValidDn.ps1

    #>
    [alias('Test-IsDN')]
    [cmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('DN', 'DistinguishedName')][string] $Identity
    )
    Process {
        [regex]$distinguishedNameRegex = '^(?:(?<cn>CN=(?<name>(?:[^,]|\,)*)),)?(?:(?<path>(?:(?:CN|OU)=(?:[^,]|\,)+,?)+),)?(?<domain>(?:DC=(?:[^,]|\,)+,?)+)$'
        $Identity -match $distinguishedNameRegex
    }
}