Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

$Computers = Get-ADComputer -Filter * -Properties OperatingSystem, OperatingSystemVersion | ForEach-Object {
    $OPS = ConvertTo-OperatingSystem -OperatingSystem $_.OperatingSystem -OperatingSystemVersion $_.OperatingSystemVersion
    Add-Member -MemberType NoteProperty -Name 'OperatingSystemTranslated' -Value $OPS -InputObject $_ -Force
    $_
}
$Computers | Select-Object DNS*, Name, SamAccountName, Enabled, OperatingSystem*, DistinguishedName | Format-Table