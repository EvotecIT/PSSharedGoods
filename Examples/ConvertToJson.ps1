Import-Module .\PSSharedGoods.psd1 -Force


$Test = [PSCustomObject] @{
    Test                   = 1
    Test1                  = $false
    Test2                  = 'Test,' + [System.Environment]::NewLine + 'test2'
    Test3                  = 'OIo*`*sd"`'
    PathWithoutSpaces      = 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
    PathWithSpaces         = "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetwork        = "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetworkAndDots = "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
}
$Test | ConvertTo-JsonLiteral -BoolAsBool -NumberAsNumber | ConvertFrom-Json | Format-Table
#$Test | ConvertTo-JsonLiteral -BoolAsBool -NumberAsNumber

$Test | ConvertTo-Json | ConvertFrom-Json





return

$Test = [PSCustomObject] @{
    Test                   = 1
    Test1                  = $false
    PathWithoutSpaces      = 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
    PathWithSpaces         = "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetwork        = "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetworkAndDots = "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
}
$Test, $Test, $Test | ConvertTo-JsonLiteral | ConvertFrom-Json | Format-Table



[string] | ConvertTo-JsonLiteral | ConvertFrom-Json | Format-Table
<#
#>
Clear-Host
$Test = [PSCustomObject] @{
    <#
    Test  = 1
    Test1 = $false
    Test2 = @(
        'C:\Users\1Password.exe'
        "C:\Users\Ooops.exe"
        "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    )
    #>

    Test1 = @{
        Test2 = 2
        Test3 = [ordered] @{
            Test4 = 'test'
            Test5 = @{
                Test6 = "oops"
            }
        }
    }
}
$Test | ConvertTo-JsonLiteral -Depth 1
#$Converted = $Test | ConvertTo-JsonLiteral -Depth 1 | ConvertFrom-Json
#$Converted | Format-Table