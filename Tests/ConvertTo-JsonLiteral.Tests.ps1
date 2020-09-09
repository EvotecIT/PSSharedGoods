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
            Int  = '1'
            Bool = $false
            Date = $DateTime
            Enum = [Fruit]::Kiwi
        }
        $Json = ConvertTo-JsonLiteral -Object $Object
        $FromJson = $Json | ConvertFrom-Json

        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
    }
    It 'Ordered Dictionary/Hashtable Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = [ordered] @{
            Int  = '1'
            Bool = $false
            Date = $DateTime
            Enum = [Fruit]::Kiwi
        }
        $Json = ConvertTo-JsonLiteral -Object $Object
        $FromJson = $Json | ConvertFrom-Json

        $FromJson.Int | Should -Be '1'
        $FromJson.Bool | Should -Be 'False'
        $FromJson.Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson.Enum | Should -Be 'Kiwi'
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
            Int  = '1'
            Bool = $false
            Date = $DateTime
            Enum = [Fruit]::Kiwi
        }
        $Json = ConvertTo-JsonLiteral -Object $Object, $Object
        $FromJson = $Json | ConvertFrom-Json

        $FromJson[0].Int | Should -Be '1'
        $FromJson[0].Bool | Should -Be 'False'
        $FromJson[0].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[0].Enum | Should -Be 'Kiwi'
        $FromJson[1].Int | Should -Be '1'
        $FromJson[1].Bool | Should -Be 'False'
        $FromJson[1].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[1].Enum | Should -Be 'Kiwi'
    }
    It 'Ordered Dictionary/Hashtable Conversion' {
        Enum Fruit{
            Apple = 29
            Pear = 30
            Kiwi = 31
        }
        $DateTime = Get-Date
        $Object = [ordered] @{
            Int  = '1'
            Bool = $false
            Date = $DateTime
            Enum = [Fruit]::Kiwi
        }
        $Json = ConvertTo-JsonLiteral -Object $Object, $Object
        $FromJson = $Json | ConvertFrom-Json

        $FromJson[0].Int | Should -Be '1'
        $FromJson[0].Bool | Should -Be 'False'
        $FromJson[0].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[0].Enum | Should -Be 'Kiwi'
        $FromJson[1].Int | Should -Be '1'
        $FromJson[1].Bool | Should -Be 'False'
        $FromJson[1].Date | Should -Be $DateTime.ToString("yyyy-MM-dd HH:mm:ss")
        $FromJson[1].Enum | Should -Be 'Kiwi'
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