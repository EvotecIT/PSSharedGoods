Import-Module .\PSSharedGoods.psd1 -Force


$PSCustomObject = [PSCustomObject] @{
    Test  = 1
    Test2 = 2
    Test3 = [PSCustomObject] @{
        IdontWantThat = [PSCustomObject] @{
            Test  = 2
            Test1 = 2
        }
        Test = 'String'
    }
}
#$PSCustomObject | ConvertTo-JsonLiteral -Depth 2 | Add-Content 'C:\Support\GitHub\PSSharedGoods\Ignore\test.json'
#$PSCustomObject | ConvertTo-Json -Depth 2 | Add-Content 'C:\Support\GitHub\PSSharedGoods\Ignore\test.json'
#return

<#
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
$Test | ConvertTo-JsonLiteral -BoolAsBool -NumberAsNumber | ConvertFrom-Json #| Format-Table
$Test | ConvertTo-Json | ConvertFrom-Json

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
#>

Clear-Host
$Test = [PSCustomObject] @{
    PSCustomObject = [PSCustomObject] @{
        Test = 1
    }
    NestedArray    = @()
    Test           = $nul

}
$Test | ConvertTo-JsonLiteral -Depth 5 -NumberAsString | ConvertFrom-Json
$Test | ConvertTo-Json | ConvertFrom-Json
#$Converted = $Test | ConvertTo-JsonLiteral -Depth 5 | ConvertFrom-Json
#$Converted


#$Test | ConvertTo-Json

$PSCustomObject = [PSCustomObject] @{
    Int                    = '1'
    Bool                   = $false
    Date                   = $DateTime
    Enum                   = [Fruit]::Kiwi
    String                 = 'This a test, or maybe not;'
    NewLine                = 'Test,' + [System.Environment]::NewLine + 'test2'
    Quotes                 = 'OIo*`*sd"`'
    PathWithoutSpaces      = 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
    PathWithSpaces         = "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetwork        = "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetworkAndDots = "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    EmptyArray             = @()
    HashTable              = @{
        NumberAgain       = 2
        OrderedDictionary = [ordered] @{
            String    = 'test'
            HashTable = @{
                StringAgain = "oops"
            }
        }
        Array             = @(
            'C:\Users\1Password.exe'
            "C:\Users\Ooops.exe"
            "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
            "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        )
    }
}

$PSCustomObject | ConvertTo-JsonLiteral -Depth 5 -NumberAsString