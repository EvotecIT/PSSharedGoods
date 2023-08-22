#
# These tests are made for visual inspection of the output of ConvertFrom-ObjectToString
# Inside a pipeline they are useful to see that their running
Describe "ConvertFrom-ObjectToString" {
    It "Converts an object to hashtable" {
        $Object = [PSCustomObject]@{
            Nothing  = $null
            List     = @('a', $null, 'c')
            'List 2' = @(1, 2, 3)
            Hash     = @{ String = "content"; Int = 1 }
            Name     = 'John'
            Age      = 30
            Float    = 1.234
            Now      = Get-Date -Year 2020 -Month 1 -Day 1 -Hour 12 -Minute 34 -Second 56
        }
        $Object | ConvertFrom-ObjectToString -OutputType Hashtable -InformationVariable informationVariable
        $CatchOutput = $informationVariable -join "`r`n"
        $TestOutput = [scriptblock]::Create($CatchOutput).Invoke()
        $TestOutput.Nothing | Should -BeExactly $Object.Nothing
        $TestOutput.List | Should -BeExactly $Object.List
        $TestOutput.'List 2' | Should -BeExactly $Object.'List 2'
        $TestOutput.Hash.String | Should -BeExactly $Object.Hash.String
        $TestOutput.Hash.Int | Should -BeExactly $Object.Hash.Int
        $TestOutput.Name | Should -BeExactly $Object.Name
        $TestOutput.Age | Should -BeExactly $Object.Age
        $TestOutput.Float | Should -BeExactly $Object.Float

        $Expectation = @'

@{
    Nothing = $null
    List = @('a', $null, 'c')
    'List 2' = @(1, 2, 3)
    Hash = @{String = 'content'; Int = 1}
    Name = 'John'
    Age = 30
    Float = 1.234
    Now = '2020-01-01 12:34:56'
}
'@
        $Expectation = $Expectation -split "`r`n"
        for ($i = 1; $i -lt $Expectation.Length; $i++) {
            $Expectation[$i] | Should -BeExactly $informationVariable[$i].ToString()
        }

    }
    It "Converts an object as ordered hashtable using excludes" {
        $Object = [PSCustomObject]@{
            Nothing  = $null
            List     = @('a', $null, 'c', 1)
            'List 2' = @(1, 2, 3)
            Hash     = @{ String = "content"; Int = 1 }
            Name     = 'John'
            Age      = 30
            Float    = 1.234
        }
        $Object | ConvertFrom-ObjectToString -OutputType Ordered -ExcludeProperties 'Nothing', 'List 2' -InformationVariable informationVariable
        $CatchOutput = $informationVariable -join "`r`n"
        $TestOutput = [scriptblock]::Create($CatchOutput).Invoke()
        $TestOutput.List | Should -BeExactly $Object.List
        $TestOutput.Hash.String | Should -BeExactly $Object.Hash.String
        $TestOutput.Hash.Int | Should -BeExactly $Object.Hash.Int
        $TestOutput.Name | Should -BeExactly $Object.Name
        $TestOutput.Age | Should -BeExactly $Object.Age
        $TestOutput.Float | Should -BeExactly $Object.Float
        $TestOutput.Keys -notcontains 'List 2' | Should -BeExactly $true
        $TestOutput.Keys -notcontains 'Nothing' | Should -BeExactly $true

        $Expectation = @'

[Ordered] @{
    List = @('a', $null, 'c', 1)
    Hash = @{String = 'content'; Int = 1}
    Name = 'John'
    Age = 30
    Float = 1.234
}
'@
        $Expectation = $Expectation -split "`r`n"
        for ($i = 1; $i -lt $Expectation.Length; $i++) {
            $Expectation[$i] | Should -BeExactly $informationVariable[$i].ToString()
        }

    }
    It "Converts a hashtable number as string, quote all property names" {
        $Object = [ordered] @{
            Nothing  = $null
            List     = @('a', $null, 'c')
            'List 2' = @(1, 2, 3)
            Hash     = @{ String = "content"; Int = 1 }
            Name     = [string[]]::new(4)
            Age      = 30
        }
        $object.Name[0] = 'John'
        $object.Name[1] = 'Paul'
        $object.Name[2] = 'George'
        $object.Name[3] = 'Ringo'
        $Object | ConvertFrom-ObjectToString -OutputType Hashtable -NumbersAsString -QuotePropertyNames -InformationVariable informationVariable
        $CatchOutput = $informationVariable -join "`r`n"
        $TestOutput = [scriptblock]::Create($CatchOutput).Invoke()
        $TestOutput.List | Should -BeExactly $Object.List
        $TestOutput.Hash.String | Should -BeExactly $Object.Hash.String
        $TestOutput.Hash.Int | Should -BeExactly $Object.Hash.Int
        $TestOutput.Name | Should -BeExactly $Object.Name
        $TestOutput.Age | Should -BeExactly $Object.Age
        $TestOutput.Float | Should -BeExactly $Object.Float

        $Expectation = @'

@{
    'Nothing' = $null
    'List' = @('a', $null, 'c')
    'List 2' = @('1', '2', '3')
    'Hash' = @{'String' = 'content'; 'Int' = '1'}
    'Name' = @('John', 'Paul', 'George', 'Ringo')
    'Age' = '30'
}
'@
        $Expectation = $Expectation -split "`r`n"
        for ($i = 1; $i -lt $Expectation.Length; $i++) {
            $Expectation[$i] | Should -BeExactly $informationVariable[$i].ToString()
        }
    }
}
