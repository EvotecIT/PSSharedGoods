Clear-Host
Import-Module "C:\Support\GitHub\PSSharedGoods\PSSharedGoods.psd1" -Force

$Object1 = Get-Content -Raw -LiteralPath "C:\Users\przemyslaw.klys\OneDrive - Evotec\Desktop\Comparison of Intune configuration\Enrollment restrictions\CS_Enrollment_Restrictions.json" | ConvertFrom-Json
$Object2 = Get-Content -Raw -LiteralPath "C:\Users\przemyslaw.klys\OneDrive - Evotec\Desktop\Comparison of Intune configuration\Enrollment restrictions\CS_Enrollment_Restrictions (1).json" | ConvertFrom-Json
$Object3 = [PSCustomObject] @{
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
            "Name" = "Sława Klys"
            "Age"  = "33"
        }
    )
}

$Object3 | ConvertTo-FlatObject

$OutputTest = $Object1, $Object2, $Object3 | ConvertTo-FlatObject
$OutputTest | Format-List *
$OutputTest | Format-Table





