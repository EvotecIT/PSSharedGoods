Import-Module .\PSSharedGoods.psd1 -Force

Enum Fruit{
    Apple = 29
    Pear = 30
    Kiwi = 31
}
$DateTime = Get-Date
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
    OrderedDictionary      = [ordered] @{
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

$HashTableObject = @{
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
    OrderedDictionary      = [ordered] @{
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

$OrderedObject = [ordered] @{
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
    OrderedDictionary      = [ordered] @{
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

$PSDefaultParameterValues = @{
    "It:TestCases" = @{
        PSCustomObject  = $PSCustomObject
        OrderedObject   = $OrderedObject
        HashTableObject = $HashTableObject
        DateTime        = $DateTime
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral' {
    It 'PSCustomObject Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $PSCustomObject
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
    It 'Ordered Dictionary Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $OrderedObject
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
    It 'Hashtable Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $HashTableObject
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral Pipeline' {
    It 'PSCustomObject Conversion' {
        $Json = $PSCustomObject | ConvertTo-JsonLiteral
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
    It 'Ordered Dictionary Conversion' {
        $Json = $OrderedObject | ConvertTo-JsonLiteral
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
    It 'Hashtable Conversion' {
        $Json = $HashTableObject | ConvertTo-JsonLiteral
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral Array' {
    It 'PSCustomObject Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $PSCustomObject, $PSCustomObject
        $FromJson = $Json | ConvertFrom-Json
        $FromJson[0].Int | Should -Be '1'
        $FromJson[0].Bool | Should -Be 'False'
        $FromJson[0].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[0].Enum | Should -Be 'Kiwi'
        $FromJson[0].String | Should -Be 'This a test, or maybe not;'
        $FromJson[1].Int | Should -Be '1'
        $FromJson[1].Bool | Should -Be 'False'
        $FromJson[1].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[1].Enum | Should -Be 'Kiwi'
        $FromJson[1].String | Should -Be 'This a test, or maybe not;'
        $FromJson[0].PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson[0].PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[0].PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[0].PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson[1].PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
    It 'Ordered Dictionary Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $OrderedObject, $OrderedObject
        $FromJson = $Json | ConvertFrom-Json
        $FromJson[0].Int | Should -Be '1'
        $FromJson[0].Bool | Should -Be 'False'
        $FromJson[0].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[0].Enum | Should -Be 'Kiwi'
        $FromJson[0].String | Should -Be 'This a test, or maybe not;'
        $FromJson[1].Int | Should -Be '1'
        $FromJson[1].Bool | Should -Be 'False'
        $FromJson[1].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[1].Enum | Should -Be 'Kiwi'
        $FromJson[1].String | Should -Be 'This a test, or maybe not;'
        $FromJson[0].PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson[0].PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[0].PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[0].PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson[1].PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
    It 'Hashtable Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $HashTableObject, $HashTableObject
        $FromJson = $Json | ConvertFrom-Json
        $FromJson[0].Int | Should -Be '1'
        $FromJson[0].Bool | Should -Be 'False'
        $FromJson[0].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[0].Enum | Should -Be 'Kiwi'
        $FromJson[0].String | Should -Be 'This a test, or maybe not;'
        $FromJson[1].Int | Should -Be '1'
        $FromJson[1].Bool | Should -Be 'False'
        $FromJson[1].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[1].Enum | Should -Be 'Kiwi'
        $FromJson[1].String | Should -Be 'This a test, or maybe not;'
        $FromJson[0].PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson[0].PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[0].PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[0].PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson[1].PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral Array Pipeline' {
    It 'PSCustomObject Conversion' {
        $Json = $PSCustomObject, $PSCustomObject | ConvertTo-JsonLiteral
        $FromJson = $Json | ConvertFrom-Json
        $FromJson[0].Int | Should -Be '1'
        $FromJson[0].Bool | Should -Be 'False'
        $FromJson[0].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[0].Enum | Should -Be 'Kiwi'
        $FromJson[0].String | Should -Be 'This a test, or maybe not;'
        $FromJson[1].Int | Should -Be '1'
        $FromJson[1].Bool | Should -Be 'False'
        $FromJson[1].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[1].Enum | Should -Be 'Kiwi'
        $FromJson[1].String | Should -Be 'This a test, or maybe not;'
        $FromJson[0].PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson[0].PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[0].PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[0].PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson[1].PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
    It 'Ordered Dictionary Conversion' {
        $Json = $OrderedObject, $OrderedObject | ConvertTo-JsonLiteral
        $FromJson = $Json | ConvertFrom-Json
        $FromJson[0].Int | Should -Be '1'
        $FromJson[0].Bool | Should -Be 'False'
        $FromJson[0].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[0].Enum | Should -Be 'Kiwi'
        $FromJson[0].String | Should -Be 'This a test, or maybe not;'
        $FromJson[1].Int | Should -Be '1'
        $FromJson[1].Bool | Should -Be 'False'
        $FromJson[1].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[1].Enum | Should -Be 'Kiwi'
        $FromJson[1].String | Should -Be 'This a test, or maybe not;'
        $FromJson[0].PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson[0].PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[0].PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[0].PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson[1].PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
    It 'Hashtable Conversion' {
        $Json = $HashTableObject, $HashTableObject | ConvertTo-JsonLiteral
        $FromJson = $Json | ConvertFrom-Json
        $FromJson[0].Int | Should -Be '1'
        $FromJson[0].Bool | Should -Be 'False'
        $FromJson[0].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[0].Enum | Should -Be 'Kiwi'
        $FromJson[0].String | Should -Be 'This a test, or maybe not;'
        $FromJson[1].Int | Should -Be '1'
        $FromJson[1].Bool | Should -Be 'False'
        $FromJson[1].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[1].Enum | Should -Be 'Kiwi'
        $FromJson[1].String | Should -Be 'This a test, or maybe not;'
        $FromJson[0].PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson[0].PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[0].PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[0].PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson[1].PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson[1].PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
}
Describe -Name 'Testing ConvertTo-JsonLiteral (bool as bool/number as number)' {
    It 'PSCustomObject Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $PSCustomObject -NumberAsNumber -BoolAsBool
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be 1
        $FromJson.Bool | Should -Be $false
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.NewLine | Should -Be ( -join ('Test,', [System.Environment]::NewLine, 'test2'))
        $FromJson.Quotes | Should -Be 'OIo*`*sd"`'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
    It 'Ordered Dictionary Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $OrderedObject -NumberAsNumber -BoolAsBool
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be 1
        $FromJson.Bool | Should -Be $false
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.NewLine | Should -Be ( -join ('Test,', [System.Environment]::NewLine, 'test2'))
        $FromJson.Quotes | Should -Be 'OIo*`*sd"`'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
    It 'Hashtable Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $HashTableObject -NumberAsNumber -BoolAsBool
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be 1
        $FromJson.Bool | Should -Be $false
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.NewLine | Should -Be ( -join ('Test,', [System.Environment]::NewLine, 'test2'))
        $FromJson.Quotes | Should -Be 'OIo*`*sd"`'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    }
}
Describe -Name 'Testing ConvertTo-JsonLiteral string type' {
    It 'string type conversion' {
        # Generally it should not throw
        $ConvertedObject = [string] | ConvertTo-JsonLiteral | ConvertFrom-Json
        $ConvertedObject.Module | Should -Be 'CommonLanguageRuntimeLibrary'
        $ConvertedObject.Namespace | Should -Be 'System'
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral Depth 5' {
    It 'PSCustomObject Conversion' {
        $Converted = $PSCustomObject | ConvertTo-JsonLiteral -Depth 5 | ConvertFrom-Json
        $Converted.HashTable.OrderedDictionary.HashTable.StringAgain | Should -be 'oops'
        $Converted.HashTable.Array[1] | Should -Be "C:\Users\Ooops.exe"
    }
    It 'Ordered Conversion' {
        $Converted = $OrderedObject | ConvertTo-JsonLiteral -Depth 5 | ConvertFrom-Json
        $Converted.HashTable.OrderedDictionary.HashTable.StringAgain | Should -be 'oops'
        $Converted.HashTable.Array[1] | Should -Be "C:\Users\Ooops.exe"
    }
    It 'HashTable Conversion' {
        $Converted = $HashTableObject | ConvertTo-JsonLiteral -Depth 5 | ConvertFrom-Json
        $Converted.HashTable.OrderedDictionary.HashTable.StringAgain | Should -be 'oops'
        $Converted.HashTable.Array[1] | Should -Be "C:\Users\Ooops.exe"
    }
}
Describe -Name 'Testing ConvertTo-JsonLiteral Depth 1' {
    It 'PSCustomObject Conversion' {
        $Converted = $PSCustomObject | ConvertTo-JsonLiteral -Depth 1 | ConvertFrom-Json
        $Converted.HashTable.OrderedDictionary.HashTable.StringAgain | Should -Not -Be 'oops'
        $Converted.HashTable.OrderedDictionary = "System.Collections.Specialized.OrderedDictionary"
        $Converted.HashTable.NumberAgain = "2"
        $Converted.HashTable.Array | Should -Be "System.Object[]"
    }
    It 'Ordered Conversion' {
        $Converted = $OrderedObject | ConvertTo-JsonLiteral -Depth 1 | ConvertFrom-Json
        $Converted.HashTable.OrderedDictionary.HashTable.StringAgain | Should -Not -Be 'oops'
        $Converted.HashTable.OrderedDictionary = "System.Collections.Specialized.OrderedDictionary"
        $Converted.HashTable.NumberAgain = "2"
        $Converted.HashTable.Array | Should -Be "System.Object[]"
    }
    It 'HashTable Conversion' {
        $Converted = $HashTableObject | ConvertTo-JsonLiteral -Depth 1 | ConvertFrom-Json
        $Converted.HashTable.OrderedDictionary.HashTable.StringAgain | Should -Not -Be 'oops'
        $Converted.HashTable.OrderedDictionary = "System.Collections.Specialized.OrderedDictionary"
        $Converted.HashTable.NumberAgain = "2"
        $Converted.HashTable.Array | Should -Be "System.Object[]"
    }
}