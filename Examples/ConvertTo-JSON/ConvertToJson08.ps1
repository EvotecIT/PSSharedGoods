#Import-Module PSWriteHTML -Force
Import-Module .\PSSharedGoods.psd1 -Force

$DataTable3 = @(
    [PSCustomObject] @{
        'property1' = 'Test1'
        'property2' = 'Test2'
        'property3' = @(
            [PSCustomObject] @{
                'Property1' = 'Test1'
                'Property2' = 'Test2'
                'Property3' = 'Test3'
            }
            [PSCustomObject] @{
                'Property1' = 'Test1'
                'Property2' = 'Test2'
                'Property3' = 'Test3'
            }
            [PSCustomObject] @{
                'property1' = 'Test1'
                'property2' = 'Test2'
                'property3' = 'Test3'
            }
        )
    }
    [PSCustomObject] @{
        'Property1' = 'Test1'
        'Property2' = 'Test2'
        'Property3' = 'Test3'
    }
)

# This conversion shows how you can force JSON to use property names from either first element in array or even give it property names

$DataTable3 | ConvertTo-JsonLiteral -Force -Depth 2