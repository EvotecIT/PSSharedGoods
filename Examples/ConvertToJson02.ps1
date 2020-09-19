Import-Module .\PSSharedGoods.psd1 -Force

$Test1 = [PSCustomObject] @{
    Number     = 1
    Bool       = $false
    Array      = @(
        'C:\Users\1Password.exe'
        "C:\Users\Ooops.exe"
        "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    )
    EmptyArray = @()
    EmptyList  = [System.Collections.Generic.List[string]]::new()
    HashTable  = @{
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
    DateTime = Get-Date
}

$Test = @{
    Test1 = 1
    Test2 = 2
    Test3 = 3
}

$Test | ConvertTo-JsonLiteral -Depth 1
#$Test | ConvertTo-JsonLiteral -Depth 1 | ConvertFrom-Json
#$Test | ConvertTo-Json -Depth 3