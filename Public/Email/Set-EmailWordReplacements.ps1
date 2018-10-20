function Set-EmailWordReplacements($Body, $Replace, $ReplaceWith, [switch] $RegEx) {
    if ($RegEx) {
        $Body = $Body -Replace $Replace, $ReplaceWith
    } else {
        $Body = $Body.Replace($Replace, $ReplaceWith)
    }
    return $Body
}