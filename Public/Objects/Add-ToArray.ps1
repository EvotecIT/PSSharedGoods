function Add-ToArray {
    [CmdletBinding()]
    param(
        [System.Collections.ArrayList] $List,
        [Object] $Element
    )
    #Write-Verbose "Add-ToArray - Element: $Element"
    [void] $List.Add($Element) #> $null
}
