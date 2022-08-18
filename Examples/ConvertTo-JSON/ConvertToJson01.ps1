Import-Module .\PSSharedGoods.psd1 -Force

Enum Fruit{
    Apple = 29
    Pear = 30
    Kiwi = 31
}

$ArrayGeneric = [System.Collections.Generic.List[string]]::new()
$ArrayGeneric.Add("Apple")
$ArrayGeneric.Add("Pear")
$ArrayGeneric.Add("Kiwi")

$ArrayGenericDouble = [System.Collections.Generic.List[double]]::new()
$ArrayGenericDouble.Add(29.0)
$ArrayGenericDouble.Add(30.0)
$ArrayGenericDouble.Add(31.4)


$PSCustomObject = [PSCustomObject] @{
    Int                    = '1'
    Bool                   = $false
    Date                   = $DateTime
    Enum                   = [Fruit]::Kiwi
    String                 = 'This a test, or maybe not;'
    NewLine                = 'Test,' + [System.Environment]::NewLine + 'test2'
    Quotes                 = 'OIo*`*sd"`'
    PathWithTrail          = 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe\'
    PathWithoutSpaces      = 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
    PathWithSpaces         = "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetwork        = "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetworkAndDots = "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    EmptyArray             = @()
    HashTable              = @{
        NumberAgain        = 2
        OrderedDictionary  = [ordered] @{
            String    = 'test'
            HashTable = @{
                StringAgain = "oops"
            }
        }
        Array              = @(
            'C:\Users\1Password.exe'
            "C:\Users\Ooops.exe"
            "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
            "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        )
        ArrayGeneric       = $ArrayGeneric
        ArrayGenericDouble = $ArrayGenericDouble
    }
}

$Output = $PSCustomObject | ConvertTo-JsonLiteral -Depth 5 -NumberAsString -ArrayJoin -ArrayJoinString "," | ConvertFrom-Json
$Output