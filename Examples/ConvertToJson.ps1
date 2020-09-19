Import-Module .\PSSharedGoods.psd1 -Force

$Test = [PSCustomObject] @{
    Test  = 1
    Test1 = $false
    #Test2 = 'Test,' + [System.Environment]::NewLine + 'test2'
    Test3 = 'OIo*`*sd"`'
    #PathWithoutSpaces      = 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
    #PathWithSpaces         = "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    #PathWithNetwork        = "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    #PathWithNetworkAndDots = "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
}
$Test | ConvertTo-JsonLiteral -BoolAsBool -NumberAsNumber | ConvertFrom-Json | Format-Table

$Test = [PSCustomObject] @{
    Test                   = 1
    Test1                  = $false
    PathWithoutSpaces      = 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
    PathWithSpaces         = "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetwork        = "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetworkAndDots = "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
}
$Test, $Test, $Test | ConvertTo-JsonLiteral | ConvertFrom-Json | Format-Table


#[string] | ConvertTo-JsonLiteral

[string] | ConvertTo-JsonLiteral | ConvertFrom-Json | Format-Table