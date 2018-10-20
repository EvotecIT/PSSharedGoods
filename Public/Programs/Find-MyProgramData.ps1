function Find-MyProgramData {
    [CmdletBinding()]
    param (
        $Data,
        $FindText
    )
    foreach ($Sub in $Data) {
        if ($Sub -like $FindText) {
            $Split = $Sub.Split(' ')
            return $Split[1]
        }
    }
    return ''
}