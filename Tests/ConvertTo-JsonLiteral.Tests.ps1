Import-Module .\PSSharedGoods.psd1 -Force

Describe -Name 'Testing ConvertTo-JsonLiteral' {
    It 'PSCustomObject Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = [PSCustomObject] @{
            Int    = '1'
            Bool   = $false
            Date   = $DateTime
            Enum   = [Fruit]::Kiwi
            String = 'This a test, or maybe not;'
        }
        $Json = ConvertTo-JsonLiteral -Object $Object
        $FromJson = $Json | ConvertFrom-Json

        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
    }
    It 'Ordered Dictionary Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = [ordered] @{
            Int    = '1'
            Bool   = $false
            Date   = $DateTime
            Enum   = [Fruit]::Kiwi
            String = 'This a test, or maybe not;'
        }
        $Json = ConvertTo-JsonLiteral -Object $Object
        $FromJson = $Json | ConvertFrom-Json

        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
    }
    It 'Hashtable Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = @{
            Int    = '1'
            Bool   = $false
            Date   = $DateTime
            Enum   = [Fruit]::Kiwi
            String = 'This a test, or maybe not;'
        }
        $Json = ConvertTo-JsonLiteral -Object $Object
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral Pipeline' {
    It 'PSCustomObject Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = [PSCustomObject] @{
            Int    = '1'
            Bool   = $false
            Date   = $DateTime
            Enum   = [Fruit]::Kiwi
            String = 'This a test, or maybe not;'
        }
        $Json = $Object | ConvertTo-JsonLiteral
        $FromJson = $Json | ConvertFrom-Json

        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
    }
    It 'Ordered Dictionary Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = [ordered] @{
            Int    = '1'
            Bool   = $false
            Date   = $DateTime
            Enum   = [Fruit]::Kiwi
            String = 'This a test, or maybe not;'
        }
        $Json = $Object | ConvertTo-JsonLiteral
        $FromJson = $Json | ConvertFrom-Json

        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
    }
    It 'Hashtable Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = @{
            Int    = '1'
            Bool   = $false
            Date   = $DateTime
            Enum   = [Fruit]::Kiwi
            String = 'This a test, or maybe not;'
        }
        $Json = $Object | ConvertTo-JsonLiteral
        $FromJson = $Json | ConvertFrom-Json
        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
        $FromJson.String | Should -Be 'This a test, or maybe not;'
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral Array' {
    It 'PSCustomObject Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = [PSCustomObject] @{
            Int    = '1'
            Bool   = $false
            Date   = $DateTime
            Enum   = [Fruit]::Kiwi
            String = 'This a test, or maybe not;'
        }
        $Json = ConvertTo-JsonLiteral -Object $Object, $Object
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
    }
    It 'Ordered Dictionary Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = [ordered] @{
            Int    = '1'
            Bool   = $false
            Date   = $DateTime
            Enum   = [Fruit]::Kiwi
            String = 'This a test, or maybe not;'
        }
        $Json = ConvertTo-JsonLiteral -Object $Object, $Object
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
    }
    It 'Hashtable Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = @{
            Int    = '1'
            Bool   = $false
            Date   = $DateTime
            Enum   = [Fruit]::Kiwi
            String = 'This a test, or maybe not;'
        }
        $Json = ConvertTo-JsonLiteral -Object $Object, $Object
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
    }
}

Describe -Name 'Testing ConvertTo-JsonLiteral Array Pipeline' {
    It 'PSCustomObject Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = [PSCustomObject] @{
            Int    = '1'
            Bool   = $false
            Date   = $DateTime
            Enum   = [Fruit]::Kiwi
            String = 'This a test, or maybe not;'
        }
        $Json = $Object, $Object | ConvertTo-JsonLiteral
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
    }
    It 'Ordered Dictionary Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = [ordered] @{
            Int    = '1'
            Bool   = $false
            Date   = $DateTime
            Enum   = [Fruit]::Kiwi
            String = 'This a test, or maybe not;'
        }
        $Json = $Object, $Object | ConvertTo-JsonLiteral
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
    }
    It 'Hashtable Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = @{
            Int    = '1'
            Bool   = $false
            Date   = $DateTime
            Enum   = [Fruit]::Kiwi
            String = 'This a test, or maybe not;'
        }
        $Json = $Object, $Object | ConvertTo-JsonLiteral
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
    }
}
<#
return

Enum Fruit{
    Apple = 29
    Pear = 30
    Kiwi = 31
}

$Object = [PSCustomObject] @{
    Test         = '1'
    Test2        = $false
    Date         = Get-Date
    Enum         = [Fruit]::Kiwi
}

$Object = [PSCustomObject] @{
    Test  = '1'
    Test2 = $false
    Date  = Get-Date
    Enum  = [Fruit]::Kiwi
}

$Object1 = [ordered] @{
    Test  = '1'
    Test2 = $false
    Date  = Get-Date
    Enum  = [Fruit]::Kiwi
}

#$Object, $Object, 1, $false | ConvertTo-Json

#$Json = ConvertTo-JsonLiteral -Object 1, 1, $false, $Object, $Object1
$Json = ConvertTo-JsonLiteral -Object $Object1 #, $Object #-HashTableAsIs
$Json
$Test = $Json | ConvertFrom-Json #| Format-Table
$Test

#>