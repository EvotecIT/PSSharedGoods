Describe 'Get-FilePermission' -Skip:($env:OS -ne 'Windows_NT') {
    BeforeAll {
        Import-Module Microsoft.PowerShell.Security
        Import-Module $PSScriptRoot\..\PSSharedGoods.psd1 -Force
    }

    BeforeEach {
        $FirstPath = Join-Path $TestDrive 'first'
        $SecondPath = Join-Path $TestDrive 'second'
        $null = New-Item -ItemType Directory -Path $FirstPath, $SecondPath -Force

        # Keep security descriptors in memory; never change the test directories' ACLs.
        $Identity = [System.Security.Principal.SecurityIdentifier]::new('S-1-1-0')
        $ReadACL = [System.Security.AccessControl.DirectorySecurity]::new()
        $ReadACL.AddAccessRule([System.Security.AccessControl.FileSystemAccessRule]::new(
                $Identity, [System.Security.AccessControl.FileSystemRights]::Read,
                [System.Security.AccessControl.AccessControlType]::Allow))
        $WriteACL = [System.Security.AccessControl.DirectorySecurity]::new()
        $WriteACL.AddAccessRule([System.Security.AccessControl.FileSystemAccessRule]::new(
                $Identity, [System.Security.AccessControl.FileSystemRights]::Write,
                [System.Security.AccessControl.AccessControlType]::Allow))

        Mock Get-Acl -ModuleName PSSharedGoods {
            if ($Path -eq $FirstPath) {
                $ReadACL
            } elseif ($Path -eq $SecondPath) {
                $WriteACL
            } else {
                throw 'Synthetic ACL access failure'
            }
        }
    }

    It 'reports each path with its own permissions and complete ACL object' {
        $Result = @(Get-FilePermission -Path $FirstPath, $SecondPath -IncludeACLObject)

        $Result.Count | Should -Be 2
        $Result[0].Path | Should -Be $FirstPath
        $Result[1].Path | Should -Be $SecondPath
        $Result[0].FileSystemRights | Should -Be $ReadACL.Access[0].FileSystemRights
        $Result[1].FileSystemRights | Should -Be $WriteACL.Access[0].FileSystemRights
        [object]::ReferenceEquals($Result[0].AllACL, $ReadACL) | Should -BeTrue
        [object]::ReferenceEquals($Result[1].AllACL, $WriteACL) | Should -BeTrue
    }

    It 'preserves an explicitly supplied ACL for every path and dictionary output' {
        $Result = @(Get-FilePermission -Path $FirstPath, $SecondPath -ACLS $WriteACL -IncludeACLObject -AsHashTable)

        $Result.Count | Should -Be 2
        $Result[0].Path | Should -Be $FirstPath
        $Result[1].Path | Should -Be $SecondPath
        foreach ($Item in $Result) {
            $Item | Should -BeOfType [System.Collections.IDictionary]
            $Item.FileSystemRights | Should -Be $WriteACL.Access[0].FileSystemRights
            [object]::ReferenceEquals($Item.AllACL, $WriteACL) | Should -BeTrue
        }
        Should -Invoke Get-Acl -ModuleName PSSharedGoods -Times 0 -Exactly
    }

    It 'skips an unreadable ACL and continues with the next path permissions' {
        $UnreadablePath = Join-Path $TestDrive 'unreadable'
        $null = New-Item -ItemType Directory -Path $UnreadablePath

        $Result = @(Get-FilePermission -Path $FirstPath, $UnreadablePath, $SecondPath -WarningVariable Warnings -WarningAction SilentlyContinue)

        $Result.Count | Should -Be 2
        $Result[0].Path | Should -Be $FirstPath
        $Result[1].Path | Should -Be $SecondPath
        $Result[1].FileSystemRights | Should -Be $WriteACL.Access[0].FileSystemRights
        $Warnings.Count | Should -Be 1
        $Warnings[0].Message | Should -Match ([regex]::Escape($UnreadablePath))
    }
}
