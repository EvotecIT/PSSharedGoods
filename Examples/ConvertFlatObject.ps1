Clear-Host
Import-Module "C:\Support\GitHub\PSSharedGoods\PSSharedGoods.psd1" -Force

#$Object1 = Get-Content -Raw -LiteralPath "C:\Users\przemyslaw.klys\OneDrive - Evotec\Desktop\Comparison of Intune configuration\Enrollment restrictions\CS_Enrollment_Restrictions.json" | ConvertFrom-Json
#$Object2 = Get-Content -Raw -LiteralPath "C:\Users\przemyslaw.klys\OneDrive - Evotec\Desktop\Comparison of Intune configuration\Enrollment restrictions\CS_Enrollment_Restrictions (1).json" | ConvertFrom-Json
$Object3 = [ordered] @{
    "Name"            = "Przemyslaw Klys"
    "Age"             = "30"
    "TestEmptyArray"  = @()
    "TestEmptyString" = ''
    "TestNullValue"   = $Null
    "Address"         = [ordered] @{
        "Street"  = "Kwiatowa"
        "City"    = "Warszawa"

        "Country" = [ordered] @{
            "Name" = "Poland"
        }
        List      = @(
            @{
                "Name" = "Poland"
            }
            [PSCustomObject] @{
                "Name" = "Adam Klys"
                "Age"  = "32"
                Super  = [ordered] @{
                    New  = 1
                    New2 = 3
                }
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
    ListTest          = @(
        [PSCustomObject] @{
            "Name" = "Sława Klys"
            "Age"  = "33"
        }
    )
}

@($Object3, $null) | ConvertTo-FlatObject -ExcludeProperty Oops, Other | Format-Table
ConvertTo-FlatObject -Objects @($Object3, $null) | Format-Table
ConvertTo-FlatObject -Objects @($Object3, $null) -ExcludeProperty Age, Name | Format-Table

$OutputTest = $Object1, $Object2, $Object3 | ConvertTo-FlatObject -ExcludeProperty Age
$OutputTest | Format-List