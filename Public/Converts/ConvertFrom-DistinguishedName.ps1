function ConvertFrom-DistinguishedName {
    [CmdletBinding()]
    param(
        [string[]] $DistinguishedName
    )
    $Regex = '^CN=(?<cn>.+?)(?<!\\),(?<ou>(?:(?:OU|CN).+?(?<!\\),)+(?<dc>DC.+?))$'
    $Output = foreach ($_ in $DistinguishedName) {
        $_ -match $Regex
        $Matches
    }
    $Output.cn
}