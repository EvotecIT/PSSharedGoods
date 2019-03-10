function Get-RandomFileName {
    [cmdletbinding()]
    param(
        $Length = 16,
        $Extension
    )
    $File = Get-RandomStringName -Size $Length -LettersOnly -ToLower
    return "$File.$Extension"
}