function Get-FileSize {
    [CmdletBinding()]
    param(
        $Bytes
    )
    $sizes = 'Bytes,KB,MB,GB,TB,PB,EB,ZB' -split ','
    for ($i = 0; ($Bytes -ge 1kb) -and ($i -lt $sizes.Count); $i++) {
        $Bytes /= 1kb
    }
    $N = 2;
    if ($i -eq 0) {
        $N = 0
    }
    return "{0:N$($N)} {1}" -f $Bytes, $sizes[$i]
}
