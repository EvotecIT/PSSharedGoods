Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

$Object = @{
    String        = 'test'
    AnotherObject = [ordered] @{
        Value1 = 1
        Value2 = 2
        Value3 = 2
        Value4 = 2
        Value5 = 2
    }
    SomethingElse = [PSCustomObject] @{
        Value1 = 1
        Value2 = 2
    }
    ScriptBlock   = {
        Get-ChildItem
    }
}

$NewObject = Copy-Dictionary -Dictionary $Object
$NewObject.SomethingElse.Value1 = 5
$NewObject.AnotherObject.Value1 = 5

$NewObject.AnotherObject.Value1 | Should -Be 5
$NewObject.SomethingElse.Value1 | Should -Be 5
$NewObject.ScriptBlock | Should -Be $Object.ScriptBlock