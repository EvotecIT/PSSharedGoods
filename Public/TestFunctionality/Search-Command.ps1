function Search-Command {
    [cmdletbinding()]
    param (
        [string] $CommandName
    )
    return [bool](Get-Command -Name $CommandName -ErrorAction SilentlyContinue)
}