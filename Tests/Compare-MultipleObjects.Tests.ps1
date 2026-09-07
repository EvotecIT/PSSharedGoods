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
        $expectedStatus = @{
            'Properties'           = $false
            'Name'                 = $true
            'Age'                  = $true
            'Test'                 = $true
            'EmptyArray'           = $true
            'EmptyArray1'          = $false
            'Address.List.1.Name'  = $true
            'Address.List.1.Age'   = $true
            'Address.List.2.Name'  = $false
            'Address.List.2.Age'   = $true
            'Address.List.3.Name'  = $true
            'Address.List.3.Age'   = $true
            'Address.List.4.Name'  = $true
            'Address.List.4.Age'   = $true
            'Address.Country.Name' = $false
            'Address.City'         = $true
            'Address.Street'       = $true
            'ListTest.1.Name'      = $true
            'ListTest.1.Age'       = $true
        }
        foreach ($entry in $expectedStatus.GetEnumerator()) {
            $matchingResult = @($result | Where-Object Name -EQ $entry.Key)
            $matchingResult.Count | Should -Be 1
            $matchingResult[0].Status | Should -Be $entry.Value
        }
        ($result | Where-Object Name -EQ 'Age').Source | Should -Be 30
        ($result | Where-Object Name -EQ 'Age').'1' | Should -Be 30
        $result.Count | Should -Be $expectedStatus.Count
    }
}
