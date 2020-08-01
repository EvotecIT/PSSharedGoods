Describe 'Select-Properties' {
    It 'Select-Properties - Testing Array of PSCustomObjects' {

        $Object1 = [PSCustomobject] @{
            Name1 = '1'
            Name2 = '3'
            Name3 = '5'
        }
        $Object2 = [PSCustomobject] @{
            Name4 = '2'
            Name5 = '6'
            Name6 = '7'
        }

        Select-Properties -Objects $Object1, $Object2 -AllProperties | Should -Be Name1, Name2, Name3, Name4, Name5, Name6
        $Object1, $Object2 | Select-Properties -AllProperties | Should -Be Name1, Name2, Name3, Name4, Name5, Name6
        $Object1, $Object2 | Select-Properties -AllProperties -ExcludeProperty Name6 -Property Name3 | Should -Be Name3

    }
    It 'Select-Properties - Testing Array of OrderedDictionary' {
        $Object3 = [Ordered] @{
            Name1 = '1'
            Name2 = '3'
            Name3 = '5'
        }
        $Object4 = [Ordered] @{
            Name4 = '2'
            Name5 = '6'
            Name6 = '7'
        }

        Select-Properties -Objects $Object3, $Object4 -AllProperties | Should -Be Name1, Name2, Name3, Name4, Name5, Name6
        $Object3, $Object4 | Select-Properties -AllProperties | Should -Be Name1, Name2, Name3, Name4, Name5, Name6
    }
}