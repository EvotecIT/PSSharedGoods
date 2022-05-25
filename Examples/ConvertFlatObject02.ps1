Clear-Host
Import-Module .\PSSharedGoods.psd1 -Force


# $Object3 = [PSCustomObject] @{
#     "Name" = "Przemyslaw Klys"
#     "Age"  = "30"
#     "tEST" = @("test", 'test2')

# }

$MyObject = Get-AzureADMSConditionalAccessPolicy #| Where-Object { $_.DisplayName -eq "All - Deny Basic authentication" }
$MyObject | ConvertTo-FlatObject