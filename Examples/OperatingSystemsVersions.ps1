Import-Module .\PSsharedGoods.psd1 -Force

Get-OperatingSystem | Format-Table

Get-OperatingSystem | Out-HtmlView {

} -DateTimeSortingFormat 'DD.MM.YYYY HH:mm:ss'


Get-OperatingSystem -Version '10.0 (19043)' | Format-Table