function Remove-FromArray {
    [CmdletBinding()]
    param(
        [System.Collections.ArrayList] $List,
        [Object] $Element,
        [switch] $LastElement
    )
    if ($LastElement) {
        $LastID = $List.Count - 1
        $List.RemoveAt($LastID) > $null
    } else {
        $List.Remove($Element) > $null
    }
}