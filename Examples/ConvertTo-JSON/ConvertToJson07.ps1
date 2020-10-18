#Import-Module PSWriteHTML -Force
Import-Module .\PSSharedGoods.psd1 -Force

$DataTable3 = @(
    [PSCustomObject] @{
        'property1' = 'Test1'
        'property2' = 'Test2'
    }
    [PSCustomObject] @{
        'Property1' = 'Test1'
        'Property2' = 'Test2'
        'Property3' = 'Test3'
    }
)

# This conversion shows how you can force JSON to use property names from either first element in array or even give it property names

$DataTable3 | ConvertTo-JsonLiteral -Force | ConvertFrom-Json | Format-Table
$DataTable3 | ConvertTo-JsonLiteral -PropertyName Property1, Property3 -Force | ConvertFrom-Json | Format-Table
$DataTable3 | ConvertTo-JsonLiteral | ConvertFrom-Json | Format-Table
$DataTable3 | ConvertTo-Json