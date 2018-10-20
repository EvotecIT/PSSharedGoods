function Set-EmailWordReplacementsHash {
    [CmdletBinding()]
    param (
        $Body,
        $Substitute
    )
    foreach ($Key in $Substitute.Keys) {
        Write-Verbose "Set-EmailWordReplacementsHash - Key: $Key Value: $($Substitute.$Key)"
        $Body = Set-EmailWordReplacements -Body $Body -Replace $Key -ReplaceWith $Substitute.$Key
    }
    return $Body
}