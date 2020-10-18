Import-Module .\PSSharedGoods.psd1 -Force


$Data = [PSCustomObject] @{
    Test  = 1
    Test2 = 2
    Test3 = [PSCustomObject] @{
        IdontWantThat = 1
    }
}

New-HTML {
    New-HTMLTable -DataTable $Data -DataStore JavaScript
} -FilePath $Env:USERPROFILE\Desktop\test.html -ShowHTML -Online

return
#Get-Process | Select-Object -First 2 | ConvertTo-JsonLiteral -Depth 0

Get-Process | Select-Object -First 2 | ConvertTo-Json -Depth 1 #| ConvertFrom-Json

return
$Test = Get-Process | Select-Object -First 2 -Property Threads, TotalProcessorTime | ConvertTo-JsonLiteral -Depth 2 | ConvertFrom-Json
$Test.Threads | Format-Table