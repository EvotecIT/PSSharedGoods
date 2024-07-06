function Test-IsDistinguishedName {
    <#
    .SYNOPSIS
    Determines whether a given string is a valid Distinguished Name (DN) format.
    
    .DESCRIPTION
    This function checks if the provided string matches the format of a Distinguished Name (DN) in Active Directory. It validates the structure of a DN which typically consists of Common Name (CN), Organizational Unit (OU), and Domain Component (DC) components.
    
    .PARAMETER Identity
    Specifies the string to be tested as a Distinguished Name (DN).
    
    .EXAMPLE
    Test-IsDistinguishedName -Identity "CN=John Doe,OU=Users,DC=example,DC=com"
    This example checks if the given string is a valid Distinguished Name format.
    
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