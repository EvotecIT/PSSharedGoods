function Test-Key {
    <#
    .SYNOPSIS
    Checks if a specific key exists in a configuration table.

    .DESCRIPTION
    The Test-Key function checks if a specified key exists in a given configuration table. It returns true if the key exists, and false otherwise.

    .PARAMETER ConfigurationTable
    The configuration table to search for the key.

    .PARAMETER ConfigurationSection
    The section within the configuration table where the key is located.

    .PARAMETER ConfigurationKey
    The key to check for existence in the configuration table.

    .PARAMETER DisplayProgress
    Specifies whether to display progress messages.

    .EXAMPLE
    Test-Key -ConfigurationTable $configTable -ConfigurationSection "Section1" -ConfigurationKey "Key1" -DisplayProgress $true
    Checks if the key "Key1" exists in the "Section1" of the $configTable and displays a progress message.

    .EXAMPLE
    Test-Key -ConfigurationTable $configTable -ConfigurationKey "Key2"
    Checks if the key "Key2" exists in the $configTable without displaying progress messages.
    #>
    [CmdletBinding()]
    param(
        $ConfigurationTable,
        $ConfigurationSection = "",
        $ConfigurationKey,
        $DisplayProgress = $false
    )
    if ($null -eq $ConfigurationTable) { return $false }
    try {
        $value = $ConfigurationTable.ContainsKey($ConfigurationKey)
    } catch {
        $value = $false
    }
    if ($value -eq $true) {
        if ($DisplayProgress -eq $true) {
            Write-Color @script:WriteParameters -Text "[i] ", "Parameter in configuration of ", "$ConfigurationSection.$ConfigurationKey", " exists." -Color White, White, Green, White
        }
        return $true
    } else {
        if ($DisplayProgress -eq $true) {
            Write-Color @script:WriteParameters -Text "[i] ", "Parameter in configuration of ", "$ConfigurationSection.$ConfigurationKey", " doesn't exist." -Color White, White, Red, White
        }
        return $false
    }
}