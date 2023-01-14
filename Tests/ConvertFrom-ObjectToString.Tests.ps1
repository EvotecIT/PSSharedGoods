#
# These tests are made for visual inspection of the output of ConvertFrom-ObjectToString
# Inside a pipeline they are useful to see that their running
Describe "ConvertFrom-ObjectToString" {
    It "Converts an object to hashtable" {
        $Object = [PSCustomObject]@{
            Nothing = $null
            List = @('a', $null, 'c')
            'List 2' = @(1, 2, 3)
            Hash = @{ String = "content"; Int = 1}
            Name = 'John'
            Age = 30
            Float = 1.234
            Now = Get-Date
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
            Name = [string[]]::new(4)
            Age = 30
        }
        $object.Name[0] = 'John'
        $object.Name[1] = 'Paul'
        $object.Name[2] = 'George'
        $object.Name[3] = 'Ringo'
        $Object | ConvertFrom-ObjectToString -OutputType Hashtable -NumbersAsString -QuotePropertyNames
    }
}
