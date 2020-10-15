Import-Module .\PSSharedGoods.psd1 -Force

$DataTable3 = @(
    [PSCustomObject] @{
        'Test1' = 'Test' + [System.Environment]::NewLine + 'test3';
        'Test2' = 'Test' + [System.Environment]::NewLine + 'test3' + "`n test"
        'Test3' = 'Test' + [System.Environment]::NewLine + 'test3' + "`r`n test"
        'Test4' = 'Test' + [System.Environment]::NewLine + 'test3' + "`r test"
        'Test5' = 'Test' + "`r`n" + 'test3' + "test"
        'Test6' = @"
        Test1
        Test2
        Test3

        Test4
"@
        'Test7' = 'Test' + "`n`n" + "Oops \n\n"
    }
)

$DataTable3 | ConvertTo-JsonLiteral
$DataTable3 | ConvertTo-Json

$DataTable3 | ConvertTo-JsonLiteral | ConvertFrom-Json | Format-Table
$DataTable3 | ConvertTo-Json | ConvertFrom-Json | Format-Table