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

$DateTime = Get-Date
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
    EmptyList              = [System.Collections.Generic.List[string]]::new()
    ArrayGeneric       = $ArrayGeneric
    ArrayGenericDouble = $ArrayGenericDouble
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
        ArrayGeneric       = $ArrayGeneric
        ArrayGenericDouble = $ArrayGenericDouble
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
        ArrayGeneric       = $ArrayGeneric
        ArrayGenericDouble = $ArrayGenericDouble
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
    PathWithTrail          = 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe\'
    PathWithoutSpaces      = 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
    PathWithSpaces         = "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetwork        = "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetworkAndDots = "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    EmptyArray             = @()
    EmptyList              = [System.Collections.Generic.List[string]]::new()
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
    PathWithTrail          = 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe\'
    PathWithoutSpaces      = 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
    PathWithSpaces         = "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetwork        = "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
    PathWithNetworkAndDots = "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
    EmptyArray             = @()
    EmptyList              = [System.Collections.Generic.List[string]]::new()
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

#$PSCustomObject | ConvertTo-JsonLiteral -Depth 5 -NumberAsString
#return

Describe -Name 'Testing ConvertTo-JsonLiteral' {
    It 'PSCustomObject Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $PSCustomObject -NumberAsString -BoolAsString
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithTrail | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe\'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson.EmptyList | Should -Be ''

    }
    It 'PSCustomObject Conversion with ArrayJoin' {
        $Json = ConvertTo-JsonLiteral -Object $PSCustomObject -NumberAsString -BoolAsString -ArrayJoin -ArrayJoinString "," -Depth 5
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithTrail | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe\'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson.EmptyList | Should -Be ''
        $FromJson.HashTable.ArrayGeneric | Should -Be "Apple,Pear,Kiwi"
        $FromJson.HashTable.ArrayGenericDouble | Should -Be "29,30,31.4"
        $FromJson.ArrayGeneric | Should -Be "Apple,Pear,Kiwi"
        $FromJson.ArrayGenericDouble | Should -Be "29,30,31.4"
    }
    It 'Ordered Dictionary Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $OrderedObject -NumberAsString -BoolAsString
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithTrail | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe\'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson.EmptyList | Should -Be ''
    }
    It 'Hashtable Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $HashTableObject -NumberAsString -BoolAsString
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithTrail | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe\'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson.EmptyList | Should -Be ''
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral Pipeline' {
    It 'PSCustomObject Conversion' {
        $Json = $PSCustomObject | ConvertTo-JsonLiteral -NumberAsString -BoolAsString
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithTrail | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe\'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson.EmptyList | Should -Be ''
    }
    It 'Ordered Dictionary Conversion' {
        $Json = $OrderedObject | ConvertTo-JsonLiteral -NumberAsString -BoolAsString
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithTrail | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe\'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson.EmptyList | Should -Be ''
    }
    It 'Hashtable Conversion' {
        $Json = $HashTableObject | ConvertTo-JsonLiteral -NumberAsString -BoolAsString
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
        $FromJson.PathWithTrail | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe\'
        $FromJson.PathWithoutSpaces | Should -Be 'C:\Users\przemyslaw.klys\AppData\Local\1password\app\7\1Password.exe'
        $FromJson.PathWithSpaces | Should -Be "C:\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetwork | Should -Be "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.PathWithNetworkAndDots | Should -Be "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $FromJson.EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson.EmptyList | Should -Be ''
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral Array' {
    It 'PSCustomObject Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $PSCustomObject, $PSCustomObject -NumberAsString -BoolAsString
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
        $FromJson[0].EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson[1].EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson[0].EmptyList | Should -Be ''
        $FromJson[1].EmptyList | Should -Be ''
    }
    It 'Ordered Dictionary Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $OrderedObject, $OrderedObject -NumberAsString -BoolAsString
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
        $FromJson[0].EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson[1].EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson[0].EmptyList | Should -Be ''
        $FromJson[1].EmptyList | Should -Be ''
    }
    It 'Hashtable Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $HashTableObject, $HashTableObject -NumberAsString -BoolAsString
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
        $FromJson[0].EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson[1].EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson[0].EmptyList | Should -Be ''
        $FromJson[1].EmptyList | Should -Be ''
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral Array Pipeline' {
    It 'PSCustomObject Conversion' {
        $Json = $PSCustomObject, $PSCustomObject | ConvertTo-JsonLiteral -NumberAsString -BoolAsString
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
        $FromJson[0].EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson[1].EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson[0].EmptyList | Should -Be ''
        $FromJson[1].EmptyList | Should -Be ''
    }
    It 'Ordered Dictionary Conversion' {
        $Json = $OrderedObject, $OrderedObject | ConvertTo-JsonLiteral -NumberAsString -BoolAsString
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
        $FromJson[0].EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson[1].EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson[0].EmptyList | Should -Be ''
        $FromJson[1].EmptyList | Should -Be ''
    }
    It 'Hashtable Conversion' {
        $Json = $HashTableObject, $HashTableObject | ConvertTo-JsonLiteral -NumberAsString -BoolAsString
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
        $FromJson[0].EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson[1].EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson[0].EmptyList | Should -Be ''
        $FromJson[1].EmptyList | Should -Be ''
    }
}
Describe -Name 'Testing ConvertTo-JsonLiteral (bool as bool/number as number)' {
    It 'PSCustomObject Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $PSCustomObject
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
        $FromJson.EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson.EmptyList | Should -Be ''
    }
    It 'Ordered Dictionary Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $OrderedObject
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
        $FromJson.EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson.EmptyList | Should -Be ''
    }
    It 'Hashtable Conversion' {
        $Json = ConvertTo-JsonLiteral -Object $HashTableObject
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
        $FromJson.EmptyArray | Should -Be '' # when no depth, no array at all.
        $FromJson.EmptyList | Should -Be ''
    }
}
Describe -Name 'Testing ConvertTo-JsonLiteral string type' {
    It 'string type conversion' {
        # Generally it should not throw
        $ConvertedObject = [string] | ConvertTo-JsonLiteral | ConvertFrom-Json
        #$ConvertedObject.Module | Should -Be 'CommonLanguageRuntimeLibrary'
        $ConvertedObject.Namespace | Should -Be 'System'
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral Depth 5' {
    It 'PSCustomObject Conversion' {
        $Converted = $PSCustomObject | ConvertTo-JsonLiteral -Depth 5 | ConvertFrom-Json
        $Converted.HashTable.OrderedDictionary.HashTable.StringAgain | Should -Be 'oops'
        $Converted.HashTable.Array[1] | Should -Be "C:\Users\Ooops.exe"
    }
    It 'Ordered Conversion' {
        $Converted = $OrderedObject | ConvertTo-JsonLiteral -Depth 5 | ConvertFrom-Json
        $Converted.HashTable.OrderedDictionary.HashTable.StringAgain | Should -Be 'oops'
        $Converted.HashTable.Array[1] | Should -Be "C:\Users\Ooops.exe"
    }
    It 'HashTable Conversion' {
        $Converted = $HashTableObject | ConvertTo-JsonLiteral -Depth 5 | ConvertFrom-Json
        $Converted.HashTable.OrderedDictionary.HashTable.StringAgain | Should -Be 'oops'
        $Converted.HashTable.Array[1] | Should -Be "C:\Users\Ooops.exe"
    }
}
Describe -Name 'Testing ConvertTo-JsonLiteral Depth 1' {
    It 'PSCustomObject Conversion' {
        $Converted = $PSCustomObject | ConvertTo-JsonLiteral -Depth 1 -NumberAsString -BoolAsString | ConvertFrom-Json
        $Converted.HashTable.OrderedDictionary.HashTable.StringAgain | Should -Not -Be 'oops'
        $Converted.HashTable.OrderedDictionary = "System.Collections.Specialized.OrderedDictionary"
        $Converted.HashTable.NumberAgain = "2"
        $Converted.HashTable.Array | Should -Be "C:\Users\1Password.exe C:\Users\Ooops.exe \\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe \\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $Converted.EmptyArray | Should -Be @()
        $Converted.EmptyList | Should -Be @()
    }
    It 'Ordered Conversion' {
        $Converted = $OrderedObject | ConvertTo-JsonLiteral -Depth 1 -NumberAsString -BoolAsString | ConvertFrom-Json
        $Converted.HashTable.OrderedDictionary.HashTable.StringAgain | Should -Not -Be 'oops'
        $Converted.HashTable.OrderedDictionary = "System.Collections.Specialized.OrderedDictionary"
        $Converted.HashTable.NumberAgain = "2"
        $Converted.HashTable.Array | Should -Be "C:\Users\1Password.exe C:\Users\Ooops.exe \\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe \\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $Converted.EmptyArray | Should -Be @()
        $Converted.EmptyList | Should -Be @()
    }
    It 'HashTable Conversion' {
        $Converted = $HashTableObject | ConvertTo-JsonLiteral -Depth 1 -NumberAsString -BoolAsString | ConvertFrom-Json
        $Converted.HashTable.OrderedDictionary.HashTable.StringAgain | Should -Not -Be 'oops'
        $Converted.HashTable.OrderedDictionary = "System.Collections.Specialized.OrderedDictionary"
        $Converted.HashTable.NumberAgain = "2"
        $Converted.HashTable.Array | Should -Be "C:\Users\1Password.exe C:\Users\Ooops.exe \\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe \\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        $Converted.EmptyArray | Should -Be @()
        $Converted.EmptyList | Should -Be @()
    }
}
Describe -Name 'Testing ConvertTo-JsonLiteral NewLines' {
    It 'Converts the same way ConvertTo-JSON' {
        $DataTable3 = @(
            [PSCustomObject] @{
                'Test1'        = 'Test' + [System.Environment]::NewLine + 'test3';
                'Test2'        = 'Test' + [System.Environment]::NewLine + 'test3' + "`n test"
                'Test3'        = 'Test' + [System.Environment]::NewLine + 'test3' + "`r`n test"
                'Test4'        = 'Test' + [System.Environment]::NewLine + 'test3' + "`r test"
                'Test5'        = 'Test' + "`r`n" + 'test3' + "test"
                'Test6'        = @"
                Test1
                Test2
                Test3

                Test4
"@
                'Test7'        = 'Test' + "`n`n" + "Oops \n\n"
                'Test8"Oopps"' = 'MyTest "Ofcourse"'
                "Test9'Ooops'" = "MyTest 'Ofcourse'"
            }
        )

        $Output1 = $DataTable3 | ConvertTo-JsonLiteral | ConvertFrom-Json
        $Output2 = $DataTable3 | ConvertTo-Json | ConvertFrom-Json
        $Output1.Test1 | Should -Be $Output2.Test1
        $Output1.Test2 | Should -Be $Output2.Test2
        $Output1.Test3 | Should -Be $Output2.Test3
        $Output1.Test4 | Should -Be $Output2.Test4
        $Output1.Test5 | Should -Be $Output2.Test5
        $Output1.Test6 | Should -Be $Output2.Test6
        $Output1.'Test8"Oopps"' | Should -Be $Output2.'Test8"Oopps"'
        $Output1."Test9'Ooops'" | Should -Be $Output2."Test9'Ooops'"
    }
}


Describe -Name 'Testing ConvertTo-JsonLiteral Using Force' {
    It 'Forces convesion according to first object in array' {
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

        $Output1 = $DataTable3 | ConvertTo-JsonLiteral -Force | ConvertFrom-Json
        $Output1[0].PSObject.Properties.Name.Count | Should -Be 2
        $Output1[1].PSObject.Properties.Name.Count | Should -Be 2
    }
    It 'Forces convesion according to first object in array' {
        $DataTable3 = @(
            [PSCustomObject] @{
                'Property1' = 'Test1'
                'Property2' = 'Test2'
                'Property3' = 'Test3'
            }
            [PSCustomObject] @{
                'property1' = 'Test1'
                'property2' = 'Test2'
            }
        )
        $Output1 = $DataTable3 | ConvertTo-JsonLiteral -Force | ConvertFrom-Json
        $Output1[0].PSObject.Properties.Name.Count | Should -Be 3
        $Output1[1].PSObject.Properties.Name.Count | Should -Be 3
        ($Output1[1].PSObject.Properties.Name)[0] | Should -BeExactly 'Property1' # checks case
        ($Output1[1].PSObject.Properties.Name)[1] | Should -BeExactly 'Property2' # checks case
    }
}


Describe -Name 'Testing ConvertTo-JsonLiteral Using Force' {
    It 'Forces convesion according to first object in array' {
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
            }
        )

        $Output1 = $DataTable3 | ConvertTo-JsonLiteral -Force -Depth 2 | ConvertFrom-Json
        $Output1[0].PSObject.Properties.Name.Count | Should -Be 3
        $Output1[1].PSObject.Properties.Name.Count | Should -Be 3
        $Output1[0].property3[0].PSObject.Properties.Name.Count | Should -Be 3
        $Output1[0].property3[1].PSObject.Properties.Name.Count | Should -Be 3
        $Output1[0].property3[2].PSObject.Properties.Name.Count | Should -Be 3
        ($Output1[0].property3[0].PSObject.Properties.Name)[0] | Should -BeExactly 'Property1'
        ($Output1[0].property3[0].PSObject.Properties.Name)[1] | Should -BeExactly 'Property2'
        ($Output1[0].property3[1].PSObject.Properties.Name)[0] | Should -BeExactly 'Property1'
        ($Output1[0].property3[1].PSObject.Properties.Name)[1] | Should -BeExactly 'Property2'
        ($Output1[0].property3[2].PSObject.Properties.Name)[0] | Should -BeExactly 'Property1'
        ($Output1[0].property3[2].PSObject.Properties.Name)[1] | Should -BeExactly 'Property2'
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral with more escaping check' {
    It 'Makes sure escaping is done properly' {
        $DataTable3 = @(
            [PSCustomObject] @{
                'Tree Parent?'                                      = 'Testing Tree ?'
                'Other Tree (Rigth)'                                = 'Ok You mean Me (Test)'
                'Hierarchy Table Recaluculation interval (minutes)' = "\\*\NETLOGON"
                "Test"                                              = "\\Ooops\C$\Windows\System32\config\netlogon.dns"
                "\\*\SYSVOL"                                        = 'Test me \\*\SYSVOL and \\*\NETLOGON shares.'
                "\\*\NETLOGON"                                      = 'Test me \\*\SYSVOL and \\*\NETLOGON shares.'
                'Test^'                                             = 'Oops1'
                "Hello+Motto"                                       = 'Oops2'
                'Hello|Motto'                                       = 'Oops3'
                'Hello{Value}'                                      = 'Oops4'
                'Hello$Value'                                       = 'Oops5'
                'Hello.Value'                                       = 'Oops6'
                'Hello Value'                                       = 'Oops7.Test'
            }
        )

        $Output1 = $DataTable3 | ConvertTo-JsonLiteral | ConvertFrom-Json
        $Output1[0].PSObject.Properties.Name.Count | Should -Be 13
        $Output1[0].'Tree Parent?' | Should -BeExactly 'Testing Tree ?'
        $Output1[0].'Other Tree (Rigth)' | Should -BeExactly 'Ok You mean Me (Test)'
        $Output1[0].'Hierarchy Table Recaluculation interval (minutes)' | Should -BeExactly '\\*\NETLOGON'
        $Output1[0].'Test' | Should -BeExactly '\\Ooops\C$\Windows\System32\config\netlogon.dns'
        $Output1[0].'\\*\SYSVOL' | Should -BeExactly 'Test me \\*\SYSVOL and \\*\NETLOGON shares.'
        $Output1[0].'\\*\NETLOGON' | Should -BeExactly 'Test me \\*\SYSVOL and \\*\NETLOGON shares.'
        $Output1[0].'Test^' | Should -BeExactly 'Oops1'
        $Output1[0].'Hello+Motto' | Should -BeExactly 'Oops2'
        $Output1[0].'Hello|Motto' | Should -BeExactly 'Oops3'
        $Output1[0].'Hello{Value}' | Should -BeExactly 'Oops4'
        $Output1[0].'Hello$Value' | Should -BeExactly 'Oops5'
        $Output1[0].'Hello.Value' | Should -BeExactly 'Oops6'
        $Output1[0].'Hello Value' | Should -BeExactly 'Oops7.Test'
    }
}


Describe -Name 'Testing ConvertTo-JsonLiteral against int/double' {
    It 'Make sure int/double works' {
        $DataTable3 = @(
            [PSCustomObject] @{
                Test1 = 1
                Test2 = 1.2
                Test3 = 1.2, 1.3, 1.4
                Test4 = 1, 2, 3, 4, 5
                Test5 = 1, 1.2, 1.3, 4
            }
        )

        $Output1 = $DataTable3 | ConvertTo-JsonLiteral -Depth 2 | ConvertFrom-Json
        $Output1[0].'Test1' | Should -BeExactly 1
        $Output1[0].'Test2' | Should -BeExactly 1.2
        $Output1[0].'Test3' | Should -BeExactly @(1.2, 1.3, 1.4)
        $Output1[0].'Test4' | Should -BeExactly @(1, 2, 3, 4, 5)
        $Output1[0].'Test5' | Should -BeExactly @(1, 1.2, 1.3, 4)
    }
}