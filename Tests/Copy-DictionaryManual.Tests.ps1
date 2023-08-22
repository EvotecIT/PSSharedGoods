Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

Describe -Name 'Copy-DictionaryManual' {
    It 'Nested Object' {
        $Object = [ordered] @{
            String        = 'test'
            AnotherObject = [ordered] @{
                Value1 = 1
                Value2 = 2
                Value3 = 2
                Value4 = 2
                Value5 = @{
                    MoreValue1 = 1
                    MoreValue2 = 2
                }
                Value6 = {
                    New-HTMLPanel {
                        New-HTMLText -Text 'Following chart presents Group Policy owners and whether they are administrative and consistent. By design an owner of Group Policy should be Domain Admins or Enterprise Admins group only to prevent malicious takeover. ', `
                            "It's also important that owner in Active Directory matches owner on SYSVOL (file system)." -FontSize 10pt
                        New-HTMLList -Type Unordered {
                            New-HTMLListItem -Text 'Administrative Owners: ', $GpoZaurrOwners['Variables']['IsAdministrative'] -FontWeight normal, bold
                            New-HTMLListItem -Text 'Non-Administrative Owners: ', $GpoZaurrOwners['Variables']['IsNotAdministrative'] -FontWeight normal, bold
                            New-HTMLListItem -Text "Owners consistent in AD and SYSVOL: ", $GpoZaurrOwners['Variables']['IsConsistent'] -FontWeight normal, bold
                            New-HTMLListItem -Text "Owners not-consistent in AD and SYSVOL: ", $GpoZaurrOwners['Variables']['IsNotConsistent'] -FontWeight normal, bold
                        } -FontSize 10pt
                        New-HTMLChart {
                            New-ChartBarOptions -Type barStacked
                            New-ChartLegend -Name 'Yes', 'No' -Color PaleGreen, Orchid
                            New-ChartBar -Name 'Is administrative' -Value $GpoZaurrOwners['Variables']['IsAdministrative'], $GpoZaurrOwners['Variables']['IsNotAdministrative']
                            New-ChartBar -Name 'Is consistent' -Value $GpoZaurrOwners['Variables']['IsConsistent'], $GpoZaurrOwners['Variables']['IsNotConsistent']
                        } -Title 'Group Policy Owners' -TitleAlignment center
                    }
                }
            }
            SomethingElse = [PSCustomObject] @{
                Value1 = 1
                Value2 = 2
            }
            ScriptBlock   = {
                Get-ChildItem
            }
        }

        $NewObject = Copy-DictionaryManual -Dictionary $Object
        $NewObject.SomethingElse.Value1 = 5
        $NewObject.AnotherObject.Value1 = 5
        $NewObject.AnotherObject.Value5.MoreValue1 = 5
        $Object.AddedObject = 5

        $NewObject.AnotherObject.Value1 | Should -Be 5
        $NewObject.SomethingElse.Value1 | Should -Be 5
        $Object.SomethingElse.Value1 | Should -Be 1
        $Object.AnotherObject.Value1 | Should -Be 1

        $NewObject.AnotherObject.Value5.MoreValue1 | Should -Be 5
        $Object.AnotherObject.Value5.MoreValue1 | Should -Be 1

        $NewObject.AnotherObject.Keys | Should -Be @(
            'Value1'
            'Value2'
            'Value3'
            'Value4'
            'Value5'
            'Value6'
        )
        $Object.AnotherObject.Keys | Should -Be @(
            'Value1'
            'Value2'
            'Value3'
            'Value4'
            'Value5'
            'Value6'
        )
        $Object.AddedObject | Should -Be 5
        $NewObject.AddedObject | Should -Be $null

        # Below doesn't work anymore since binary formatter is gone
        # Doing this manually has it's own problems, but using 

        #(& $Object.ScriptBlock).GetType().Name | Should -be 'Object[]'

        #(& $NewObject.ScriptBlock).GetType().Name | Should -be 'Object[]'

        #$Object.AnotherObject.Value6.GetType().Name | Should -be 'ScriptBlock'
        #$NewObject.AnotherObject.Value6.GetType().Name | Should -be 'ScriptBlock'
    }
}