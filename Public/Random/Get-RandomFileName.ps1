function Get-RandomFileName {
    <#
    .SYNOPSIS
    Generates a random file name with a specified length and extension.

    .DESCRIPTION
    This function generates a random file name with a specified length and extension. The file name is created using random letters only.

    .PARAMETER Length
    The length of the random file name to generate. Default is 16.

    .PARAMETER Extension
    The extension to append to the random file name.

    .EXAMPLE
    Get-RandomFileName -Length 8 -Extension "txt"
    Generates a random file name with a length of 8 characters and appends the extension ".txt".

    .EXAMPLE
    Get-RandomFileName -Extension "docx"
    Generates a random file name with a default length of 16 characters and appends the extension ".docx".
    #>
    [cmdletbinding()]
    param(
        $Length = 16,
        $Extension
    )
    $File = Get-RandomStringName -Size $Length -LettersOnly -ToLower
    return "$File.$Extension"
}