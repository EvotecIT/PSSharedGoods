Clear-Host
Import-Module .\PSSharedGoods.psd1 -Force

$Object1 = [PSCustomObject] @{
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
$Object2 = [PSCustomObject] @{
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

#Compare-MultipleObjects -Objects $Object1, $Object2 -FlattenObject -Summary -ObjectsName "test",'test1' | Format-Table *
Compare-MultipleObjects -Objects $Object1, $null -FlattenObject -Summary -ObjectsName "test",'test1' | Format-Table *
#Compare-MultipleObjects -Objects $Object1, $null -ObjectsName "test",'test1' | Format-Table *


$Object1 = [PSCustomObject] @{
    Value0 = $true
    Value3 = "old"
    Value1 = $null
}
$Object2 = [PSCustomObject] @{
    Value0 = $true
    Value3 = ''
    Value2 = $false
}

Compare-MultipleObjects -Objects $Object1, $Object2 -ObjectsName "test", 'test1' -Summary| Format-Table *