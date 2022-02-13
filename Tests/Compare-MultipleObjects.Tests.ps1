$Object15 = [PSCustomObject] @{
    "Name"        = "Przemyslaw Klys"
    "Age"         = "30"
    "Test"        = $null
    "EmptyArray"  = @()
    "EmptyArray1" = @()
    "Address"     = @{
        "Street"  = "Kwiatowa"
        "City"    = "Warszawa"
        "Country" = [ordered] @{
            "Name" = "Poland"
        }
        List      = @(
            [PSCustomObject] @{
                "Name" = "Adam Klys"
                "Age"  = "32"
            }
            [PSCustomObject] @{
                "Name" = "Justyna Klys"
                "Age"  = "33"
            }
            [PSCustomObject] @{
                "Name" = "Justyna Klys"
                "Age"  = 30
            }
            [PSCustomObject] @{
                "Name" = "Justyna Klys"
                "Age"  = $null
            }
        )
    }
    ListTest      = @(
        [PSCustomObject] @{
            "Name" = "Sława Klys"
            "Age"  = "33"
        }
    )
}
$Object16 = [PSCustomObject] @{
    "Name"       = "Przemyslaw Klys"
    "Age"        = "30"
    "Test"       = $null
    "EmptyArray" = @()
    "Address"    = @{
        "Street"  = "Kwiatowa"
        "City"    = "Warszawa"
        "Country" = [ordered] @{
            "Name" = "Gruzja"
        }
        List      = @(
            [PSCustomObject] @{
                "Name" = "Adam Klys"
                "Age"  = "32"
            }
            [PSCustomObject] @{
                "Name" = "Pankracy Klys"
                "Age"  = "33"
            }
            [PSCustomObject] @{
                "Name" = "Justyna Klys"
                "Age"  = 30
            }
            [PSCustomObject] @{
                "Name" = "Justyna Klys"
                "Age"  = $null
            }
        )
    }
    ListTest     = @(
        [PSCustomObject] @{
            "Name" = "Sława Klys"
            "Age"  = "33"
        }
    )
}

$PSDefaultParameterValues = @{
    "It:TestCases" = @{
        Object1 = $Object15
        Object2 = $Object16
    }
}

Describe -Name 'Testing ConvertTo-FlatObject' {
    It 'PSCustomObject Conversion' {
        $result = Compare-MultipleObjects -Objects $Object1, $Object2
        $result[0].Status | Should -Be $false
        $result[1].Status | Should -Be $true
        $result[2].Status | Should -Be $true
        $result[2]."Source" | Should -Be 30
        $result[2]."1" | Should -Be 30
        $result[3].Status | Should -Be $true
        $result[4].Status | Should -Be $true
        $result[5].Status | Should -Be $false
        $result[6].Status | Should -Be $null
        $result[7].Status | Should -Be $null
        $result.count | Should -Be 8
    }
    It 'OrderedObject Conversion' {
        $result = Compare-MultipleObjects -Objects $Object1, $Object2 -FlattenObject
        $result[0].Status | Should -Be $false
        $result[1].Status | Should -Be $true
        $result[2].Status | Should -Be $true
        $result[2]."Source" | Should -Be 30
        $result[2]."1" | Should -Be 30
        $result[3].Status | Should -Be $true
        $result[4].Status | Should -Be $true
        $result[5].Status | Should -Be $false
        $result[6].Status | Should -Be $false
        $result[8].Status | Should -Be $true
        $result[9].Status | Should -Be $true
        $result[10].Status | Should -Be $false
        $result[11].Status | Should -Be $true
        $result[12].Status | Should -Be $true
        $result[13].Status | Should -Be $true
        $result[14].Status | Should -Be $true
        $result[15].Status | Should -Be $true
        $result[16].Status | Should -Be $true
        $result[17].Name | Should -be "ListTest.1.Name"
        $result[17].Status | Should -Be $true
        $result[18].Status | Should -Be $true
        $result[18].Name | Should -be "ListTest.1.Age"
        $result.count | Should -Be 19
    }
}