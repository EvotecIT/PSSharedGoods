$OrderedObject = [ordered] @{
    "Name"    = "Przemyslaw Klys"
    "Age"     = "30"
    "Address" = @{
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
    ListTest  = @(
        [PSCustomObject] @{
            "Name" = "Justyna Klys"
            "Age"  = "33"
        }
    )
}


$PSCustomObject = [PSCustomObject] @{
    "Name"    = "Przemyslaw Klys"
    "Age"     = "30"
    "Address" = @{
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
    ListTest  = @(
        [PSCustomObject] @{
            "Name" = "Justyna Klys"
            "Age"  = "33"
        }
    )
}

$PSDefaultParameterValues = @{
    "It:TestCases" = @{
        PSCustomObject  = $PSCustomObject
        OrderedObject   = $OrderedObject
        DateTime        = $DateTime
    }
}

Describe -Name 'Testing ConvertTo-FlatObject' {
    It 'PSCustomObject Conversion' {
        $result = ConvertTo-FlatObject $PSCustomObject
        $result.Name | Should -Be "Przemyslaw Klys"
        $result.Age | Should -Be "30"
        $result."Address.Street" | Should -Be "Kwiatowa"
        $result."Address.Country.Name" | Should -Be "Poland"
        $result."Address.City" | Should -Be "Warszawa"
        $result."Address.List.1.Name" | Should -Be "Adam Klys"
        $result."Address.List.1.Age" | Should -Be "32"
        $result."Address.List.1.Age".GetType().Name | Should -Be 'string'
        $result."Address.List.2.Name" | Should -Be "Justyna Klys"
        $result."Address.List.2.Age" | Should -Be "33"
        $result."Address.List.2.Age".GetType().Name | Should -Be 'string'
        $result."Address.List.3.Name" | Should -Be "Justyna Klys"
        $result."Address.List.3.Age" | Should -Be 30
        $result."Address.List.3.Age".GetType().Name | Should -Be 'int32'
        $result."Address.List.4.Name" | Should -Be "Justyna Klys"
        $result."Address.List.4.Age" | Should -Be $null
        $result."Address.Street" | Should -Be "Kwiatowa"
        $result."ListTest.1.Name" | Should -Be "Justyna Klys"
        $result."ListTest.1.Age" | Should -Be 33
    }
    It 'OrderedObject Conversion' {
        $result = ConvertTo-FlatObject $PSCustomObject
        $result.Name | Should -Be "Przemyslaw Klys"
        $result.Age | Should -Be "30"
        $result."Address.Street" | Should -Be "Kwiatowa"
        $result."Address.Country.Name" | Should -Be "Poland"
        $result."Address.City" | Should -Be "Warszawa"
        $result."Address.List.1.Name" | Should -Be "Adam Klys"
        $result."Address.List.1.Age" | Should -Be "32"
        $result."Address.List.1.Age".GetType().Name | Should -Be 'string'
        $result."Address.List.2.Name" | Should -Be "Justyna Klys"
        $result."Address.List.2.Age" | Should -Be "33"
        $result."Address.List.2.Age".GetType().Name | Should -Be 'string'
        $result."Address.List.3.Name" | Should -Be "Justyna Klys"
        $result."Address.List.3.Age" | Should -Be 30
        $result."Address.List.3.Age".GetType().Name | Should -Be 'int32'
        $result."Address.List.4.Name" | Should -Be "Justyna Klys"
        $result."Address.List.4.Age" | Should -Be $null
        $result."Address.Street" | Should -Be "Kwiatowa"
        $result."ListTest.1.Name" | Should -Be "Justyna Klys"
        $result."ListTest.1.Age" | Should -Be 33
    }
}