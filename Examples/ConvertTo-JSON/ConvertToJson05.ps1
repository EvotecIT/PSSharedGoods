Import-Module .\PSSharedGoods.psd1 -Force

$Test = [PSCustomObject] @{
    Number       = 1
    Bool         = $false
    'Test.Value1.2' = '5'
    'Test.Value1.3' = '6'
}

$Test, $Test, $Test | ConvertTo-JsonLiteral


$Test = [PSCustomObject] @{
    Number       = 1
    Bool         = $false
    'Test.Value1.2' = '5'
    'Test.Value1.3' = '6'
}

$Test | ConvertTo-Json