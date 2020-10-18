Import-Module .\PSSharedGoods.psd1 -Force

$Test = [PSCustomObject] @{
    Number    = 1
    Bool      = $false
    Array     = @(
        'C:\Users\1Password.exe'
        "C:\Users\Ooops.exe"
        "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    )
    HashTable = @{
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

Measure-Command {
    for ($i = 0; $i -le 1000; $i++) {
        $Test | ConvertTo-Json -Depth 1
    }
}
Measure-Command {
    for ($i = 0; $i -le 1000; $i++) {
        ConvertTo-JsonLiteral -Depth 1 -Object $Test
    }
}

Measure-Command {
    for ($i = 0; $i -le 1000; $i++) {
        $Test | ConvertTo-JsonLiteral -Depth 1
    }
}