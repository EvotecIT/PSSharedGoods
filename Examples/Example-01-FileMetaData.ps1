Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

# Option 1
Get-ChildItem -Path $Env:USERPROFILE\Desktop -Force | Get-FileMetaData -Signature -HashAlgorithm SHA256 | Out-HtmlView -ScrollX -Filtering -AllProperties
return
# Option 2
$Files = "$Env:USERPROFILE\Desktop\LAPS.x64.msi", "$Env:USERPROFILE\Desktop\DigiCertUtil.exe"
$Files | Get-FileMetaData -Signature -HashAlgorithm MD5 | Out-HtmlView -ScrollX -Filtering -AllProperties

# Option 3
Get-FileMetaData -File $Files -Signature | Out-HtmlView -ScrollX -Filtering -AllProperties

# Option 4
Get-ChildItem -Path $Env:USERPROFILE\Desktop -Force | Where-Object { $_.Attributes -like '*Hidden*' } | Get-FileMetaData -Signature | Out-HtmlView -ScrollX -Filtering -AllProperties

# Option 5
$Files = "$Env:USERPROFILE\Desktop\LAPS.x64.msi", "$Env:USERPROFILE\Desktop\DigiCertUtil.exe"
$Files | Get-FileMetaData -Signature | Format-List