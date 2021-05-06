Import-Module .\PSSharedGoods.psd1 -Force

$PSCustomObject = [PSCustomObject] @{
    Test1 = 1
    Test2 = 1.2
    Test3 = 1.2, 1.3, 1.4
    Test4 = 1, 2, 3, 4, 5
    Test5 = 1, 1.2, 1.3, 4
}

$PSCustomObject | ConvertTo-JsonLiteral -Depth 2 | ConvertFrom-Json #-NumberAsString
#$PSCustomObject | ConvertTo-Json