Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

$Object1 = [ordered] @{
    Name1 = 1
    Name2 = '3'
    Name3 = '5'
}
$Object2 = [ordered] @{
    Name1 = '1'
    Name2 = '3'
    Name3 = '5'
}
$Object3 = [ordered] @{
    Name4 = '2'
    Name5 = '6'
    Name6 = '7'
}

$Object0 = 'Test'

#$All = Select-Properties -Objects $Object1, $Object2, $Object3 -IncludeTypes -AllProperties
#$All


Select-Properties -Objects $Object1 -ExcludeProperty 'Name3','Name5'