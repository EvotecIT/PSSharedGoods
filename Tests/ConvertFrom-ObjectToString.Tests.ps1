BeforeDiscovery {
    if (-Not (Get-Module -Name PSSharedGoods)) {
        Import-Module $PSScriptRoot/../PSSharedGoods.psd1 -Force
    }
}
BeforeAll {
    if (-Not (Get-Module -Name PSSharedGoods)) {
        Import-Module $PSScriptRoot/../PSSharedGoods.psd1 -Force
    }
}

Describe "Simple objects" {
    It "Converts an object to hashtable" {
        $Object = [PSCustomObject]@{
            Nothing = $null
            List = @('a', $null, 'c')
            'List 2' = @(1, 2, 3)
            Hash = @{ String = "content"; Int = 1}
            Name = 'John'
            Age = 30
            Float = 1.234
        }
        $Object | ConvertFrom-ObjectToString -OutputType Hashtable
    }
    It "Converts an object as ordered hashtable using excludes" {
        $Object = [PSCustomObject]@{
            Nothing = $null
            List = @('a', $null, 'c', 1)
            'List 2' = @(1, 2, 3)
            Hash = @{ String = "content"; Int = 1}
            Name = 'John'
            Age = 30
            Float = 1.234
        }
        $Object | ConvertFrom-ObjectToString -OutputType Ordered -ExcludeProperties 'Nothing', 'List 2'
    }
    It "Converts a hashtable number as string, quote all property names" {
        $Object = @{
            Nothing = $null
            List = @('a', $null, 'c')
            'List 2' = @(1, 2, 3)
            Hash = @{ String = "content"; Int = 1}
            Name = 'John'
            Age = 30
        }
        $Object | ConvertFrom-ObjectToString -OutputType Hashtable -NumbersAsString -QuotePropertyNames
    }
}
