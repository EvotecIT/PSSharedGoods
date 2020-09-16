
Import-Module $PSScriptRoot\..\PSSharedGoods.psd1 -Force
Describe -Name 'Testing ConvertTo-SID' {
    It 'OnlyWellKnownAdministrative - Given 2 sids, only 1 should return' {
        $SIDs = @(
            'S-1-5-18'
            'S-1-5-19'
        )
        $OutputPS = ConvertFrom-SID -SID $SIDs -OnlyWellKnownAdministrative
        $ExpectedResult = [PSCustomObject] @{
            Name  = 'NT AUTHORITY\SYSTEM';
            SID   = 'S-1-5-18';
            Type  = 'WellKnownAdministrative';
            Error = ''
        }
        $OutputPS.Error | Should -be $ExpectedResult.Error
        $OutputPS.SID | Should -be $ExpectedResult.SID
        $OutputPS.Type | Should -be $ExpectedResult.Type
        $OutputPS.Name | Should -be $ExpectedResult.Name
    }
}
Describe -Name 'Testing ConvertTo-SID' {
    It 'OnlyWellKnown - Given 3 sids, only 2 should return' {
        $SIDs = @(
            'S-1-5-18'
            'S-1-5-19'
            'S-1-5-20-20-10-51'
        )
        $OutputPS = ConvertFrom-SID -SID $SIDs -OnlyWellKnown
        $ExpectedResult0 = [PSCustomObject] @{
            Name  = 'NT AUTHORITY\SYSTEM';
            SID   = 'S-1-5-18';
            Type  = 'WellKnownAdministrative';
            Error = ''
        }
        $ExpectedResult1 = [PSCustomObject] @{
            Name  = 'NT AUTHORITY\NETWORK SERVICE'
            SID   = 'S-1-5-19'
            Type  = 'WellKnownGroup'
            Error = ''
        }
        $OutputPS[0].Error | Should -be $ExpectedResult0.Error
        $OutputPS[0].SID | Should -be $ExpectedResult0.SID
        $OutputPS[0].Type | Should -be $ExpectedResult0.Type
        $OutputPS[0].Name | Should -be $ExpectedResult0.Name
        $OutputPS[1].Error | Should -be $ExpectedResult1.Error
        $OutputPS[1].SID | Should -be $ExpectedResult1.SID
        $OutputPS[1].Type | Should -be $ExpectedResult1.Type
        $OutputPS[1].Name | Should -be $ExpectedResult1.Name
    }
}
Describe -Name 'Testing ConvertTo-SID' {
    It 'Given 3 sids, 3 should return' {
        $SIDs = @(
            'S-1-5-18'
            'S-1-5-19'
            'S-1-5-20-20-10-51'
        )
        $OutputPS = ConvertFrom-SID -SID $SIDs -DoNotResolve
        $ExpectedResult0 = [PSCustomObject] @{
            Name  = 'NT AUTHORITY\SYSTEM';
            SID   = 'S-1-5-18';
            Type  = 'WellKnownAdministrative';
            Error = ''
        }
        $ExpectedResult1 = [PSCustomObject] @{
            Name  = 'NT AUTHORITY\NETWORK SERVICE'
            SID   = 'S-1-5-19'
            Type  = 'WellKnownGroup'
            Error = ''
        }
        # Do not resolve means return as 'NotAdministrative'
        $ExpectedResult2 = [PSCustomObject] @{
            Name  = 'S-1-5-20-20-10-51'
            SID   = 'S-1-5-20-20-10-51'
            Type  = 'NotAdministrative'
            Error = ''
        }
        $OutputPS[0].Error | Should -be $ExpectedResult0.Error
        $OutputPS[0].SID | Should -be $ExpectedResult0.SID
        $OutputPS[0].Type | Should -be $ExpectedResult0.Type
        $OutputPS[0].Name | Should -be $ExpectedResult0.Name
        $OutputPS[1].Error | Should -be $ExpectedResult1.Error
        $OutputPS[1].SID | Should -be $ExpectedResult1.SID
        $OutputPS[1].Type | Should -be $ExpectedResult1.Type
        $OutputPS[1].Name | Should -be $ExpectedResult1.Name
        $OutputPS[2].Error | Should -be $ExpectedResult2.Error
        $OutputPS[2].SID | Should -be $ExpectedResult2.SID
        $OutputPS[2].Type | Should -be $ExpectedResult2.Type
        $OutputPS[2].Name | Should -be $ExpectedResult2.Name
    }
}

Describe -Name 'Testing ConvertTo-SID' {
    It 'Given 3 sids, 3 should return' {
        $SIDs = @(
            'S-1-5-18'
            'S-1-5-19'
            'S-1-5-20-20-10-51'
        )
        $OutputPS = ConvertFrom-SID -SID $SIDs
        $ExpectedResult0 = [PSCustomObject] @{
            Name  = 'NT AUTHORITY\SYSTEM';
            SID   = 'S-1-5-18';
            Type  = 'WellKnownAdministrative';
            Error = ''
        }
        $ExpectedResult1 = [PSCustomObject] @{
            Name  = 'NT AUTHORITY\NETWORK SERVICE'
            SID   = 'S-1-5-19'
            Type  = 'WellKnownGroup'
            Error = ''
        }
        # Try to resolve and fail
        $ExpectedResult2 = [PSCustomObject] @{
            Name = 'S-1-5-20-20-10-51'
            SID  = 'S-1-5-20-20-10-51'
            Type = 'Unknown'
        }
        $OutputPS[0].Error | Should -be $ExpectedResult0.Error
        $OutputPS[0].SID | Should -be $ExpectedResult0.SID
        $OutputPS[0].Type | Should -be $ExpectedResult0.Type
        $OutputPS[0].Name | Should -be $ExpectedResult0.Name
        $OutputPS[1].Error | Should -be $ExpectedResult1.Error
        $OutputPS[1].SID | Should -be $ExpectedResult1.SID
        $OutputPS[1].Type | Should -be $ExpectedResult1.Type
        $OutputPS[1].Name | Should -be $ExpectedResult1.Name
        $OutputPS[2].Error | Should -not -BeNullOrEmpty
        $OutputPS[2].SID | Should -be $ExpectedResult2.SID
        $OutputPS[2].Type | Should -be $ExpectedResult2.Type
        $OutputPS[2].Name | Should -be $ExpectedResult2.Name
    }
}
Describe -Name 'Testing ConvertTo-SID' {
    It 'Given 3 sids, 3 should return' {
        $SIDs = @(
            'S-1-5-18'
            'S-1-5-19'
            'S-1-5-20-20-10-51'
            'S-1-5-21-853615985-2870445339-3163598659-512'
            'S-1-5-21-3661168273-3802070955-2987026695-512'
            'S-1-5-21-1928204107-2710010574-1926425344-512'
        )
        $OutputPS = ConvertFrom-SID -SID $SIDs
        $ExpectedResult0 = [PSCustomObject] @{
            Name  = 'NT AUTHORITY\SYSTEM';
            SID   = 'S-1-5-18';
            Type  = 'WellKnownAdministrative';
            Error = ''
        }
        $ExpectedResult1 = [PSCustomObject] @{
            Name  = 'NT AUTHORITY\NETWORK SERVICE'
            SID   = 'S-1-5-19'
            Type  = 'WellKnownGroup'
            Error = ''
        }
        # Try to resolve and fail
        $ExpectedResult2 = [PSCustomObject] @{
            Name = 'S-1-5-20-20-10-51'
            SID  = 'S-1-5-20-20-10-51'
            Type = 'Unknown'
        }
        $ExpectedDomainAdmins = 'Administrative'
        $OutputPS[0].Error | Should -be $ExpectedResult0.Error
        $OutputPS[0].SID | Should -be $ExpectedResult0.SID
        $OutputPS[0].Type | Should -be $ExpectedResult0.Type
        $OutputPS[0].Name | Should -be $ExpectedResult0.Name
        $OutputPS[1].Error | Should -be $ExpectedResult1.Error
        $OutputPS[1].SID | Should -be $ExpectedResult1.SID
        $OutputPS[1].Type | Should -be $ExpectedResult1.Type
        $OutputPS[1].Name | Should -be $ExpectedResult1.Name
        $OutputPS[2].Error | Should -not -BeNullOrEmpty
        $OutputPS[2].SID | Should -be $ExpectedResult2.SID
        $OutputPS[2].Type | Should -be $ExpectedResult2.Type
        $OutputPS[2].Name | Should -be $ExpectedResult2.Name

        $OutputPS[3].Type | Should -be $ExpectedDomainAdmins
        $OutputPS[4].Type | Should -be $ExpectedDomainAdmins
        $OutputPS[5].Type | Should -be $ExpectedDomainAdmins
    }
}

