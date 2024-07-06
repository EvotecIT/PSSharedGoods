function Get-FileSize {
    <#
    .SYNOPSIS
    Get-FileSize function calculates the file size in human-readable format.

    .DESCRIPTION
    This function takes a file size in bytes and converts it into a human-readable format (e.g., KB, MB, GB, etc.).

    .PARAMETER Bytes
    Specifies the size of the file in bytes.

    .EXAMPLE
    Get-FileSize -Bytes 1024
    Output: 1 KB

    .EXAMPLE
    Get-FileSize -Bytes 1048576
    Output: 1 MB
    #>
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
