Import-Module .\PSSharedGoods.psd1 -Force

$CidrObject = @{
    Ip            = '10.2.10.0'
    NetworkLength = 24
}
Get-IPAddressRangeInformation -CIDRObject $CidrObject | Format-Table

Get-IPAddressRangeInformation -Network '10.2.10.0/24' | Format-Table

Get-IPAddressRangeInformation -IPAddress '10.2.10.0' -NetworkLength 24 | Format-Table