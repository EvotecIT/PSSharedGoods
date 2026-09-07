Describe 'Initialize-ModulePortable' {
    BeforeAll {
        Import-Module $PSScriptRoot\..\*.psd1 -Force
    }

    BeforeEach {
        $PortablePath = Join-Path -Path $TestDrive -ChildPath 'Modules'
        $DependencyV1 = Join-Path -Path $PortablePath -ChildPath 'Dependency/1.0.0'
        $DependencyV2 = Join-Path -Path $PortablePath -ChildPath 'Dependency/2.0.0'
        $PrimaryV1 = Join-Path -Path $PortablePath -ChildPath 'Primary/1.0.0'
        $null = New-Item -ItemType Directory -Path $DependencyV1, $DependencyV2, $PrimaryV1 -Force

        "@{ RootModule = ''; ModuleVersion = '1.0.0'; GUID = '11111111-1111-1111-1111-111111111111' }" | Set-Content -LiteralPath (Join-Path $DependencyV1 'Dependency.psd1')
        "@{ RootModule = ''; ModuleVersion = '2.0.0'; GUID = '22222222-2222-2222-2222-222222222222' }" | Set-Content -LiteralPath (Join-Path $DependencyV2 'Dependency.psd1')
        "@{ RootModule = ''; ModuleVersion = '1.0.0'; GUID = '33333333-3333-3333-3333-333333333333'; RequiredModules = @('Dependency') }" | Set-Content -LiteralPath (Join-Path $PrimaryV1 'Primary.psd1')

        Mock Save-Module -ModuleName PSSharedGoods {}
    }

    It 'generates a path-safe loader with one latest manifest per module' {
        $PathWithTrailingSeparator = $PortablePath + [System.IO.Path]::DirectorySeparatorChar

        Initialize-ModulePortable -Name Primary -Path $PathWithTrailingSeparator -Download

        $Loader = Get-Content -LiteralPath (Join-Path $PortablePath 'Primary.ps1') -Raw
        $Loader | Should -Match "Join-Path -Path \`$PSScriptRoot -ChildPath 'Dependency/2.0.0/Dependency.psd1'"
        $Loader | Should -Match "Join-Path -Path \`$PSScriptRoot -ChildPath 'Primary/1.0.0/Primary.psd1'"
        $Loader | Should -Not -Match 'Dependency/1.0.0/Dependency.psd1'
        $Loader | Should -Not -Match '\$PSScriptRootPrimary'
        Should -Invoke -CommandName Save-Module -ModuleName PSSharedGoods -Times 1 -Exactly -ParameterFilter { $Name -eq 'Primary' -and $Force }
    }

    It 'can be run repeatedly against the same portable directory' {
        Initialize-ModulePortable -Name Primary -Path $PortablePath -Download
        $FirstLoader = Get-Content -LiteralPath (Join-Path $PortablePath 'Primary.ps1') -Raw

        Initialize-ModulePortable -Name Primary -Path $PortablePath -Download
        $SecondLoader = Get-Content -LiteralPath (Join-Path $PortablePath 'Primary.ps1') -Raw

        $SecondLoader | Should -BeExactly $FirstLoader
        Should -Invoke -CommandName Save-Module -ModuleName PSSharedGoods -Times 2 -Exactly -ParameterFilter { $Force }
    }

    It 'backtracks to a version that satisfies combined dependency constraints' {
        $SharedV1 = Join-Path -Path $PortablePath -ChildPath 'Shared/1.0.0'
        $SharedV2 = Join-Path -Path $PortablePath -ChildPath 'Shared/2.0.0'
        $ModuleA = Join-Path -Path $PortablePath -ChildPath 'ModuleA/1.0.0'
        $ModuleB = Join-Path -Path $PortablePath -ChildPath 'ModuleB/1.0.0'
        $Root = Join-Path -Path $PortablePath -ChildPath 'ConstraintRoot/1.0.0'
        $null = New-Item -ItemType Directory -Path $SharedV1, $SharedV2, $ModuleA, $ModuleB, $Root -Force

        "@{ RootModule = ''; ModuleVersion = '1.0.0'; GUID = '44444444-4444-4444-4444-444444444444' }" | Set-Content -LiteralPath (Join-Path $SharedV1 'Shared.psd1')
        "@{ RootModule = ''; ModuleVersion = '2.0.0'; GUID = '44444444-4444-4444-4444-444444444444' }" | Set-Content -LiteralPath (Join-Path $SharedV2 'Shared.psd1')
        "@{ RootModule = ''; ModuleVersion = '1.0.0'; GUID = '55555555-5555-5555-5555-555555555555'; RequiredModules = @(@{ ModuleName = 'Shared'; ModuleVersion = '1.0.0' }) }" | Set-Content -LiteralPath (Join-Path $ModuleA 'ModuleA.psd1')
        "@{ RootModule = ''; ModuleVersion = '1.0.0'; GUID = '66666666-6666-6666-6666-666666666666'; RequiredModules = @(@{ ModuleName = 'Shared'; MaximumVersion = '1.5.0' }) }" | Set-Content -LiteralPath (Join-Path $ModuleB 'ModuleB.psd1')
        "@{ RootModule = ''; ModuleVersion = '1.0.0'; GUID = '77777777-7777-7777-7777-777777777777'; RequiredModules = @('ModuleA', 'ModuleB') }" | Set-Content -LiteralPath (Join-Path $Root 'ConstraintRoot.psd1')

        Initialize-ModulePortable -Name ConstraintRoot -Path $PortablePath -Download

        $Loader = Get-Content -LiteralPath (Join-Path $PortablePath 'ConstraintRoot.ps1') -Raw
        $Loader | Should -Match "Shared/1.0.0/Shared.psd1"
        $Loader | Should -Not -Match "Shared/2.0.0/Shared.psd1"
    }

    It 'honors GUID-qualified required modules' {
        $IdentityV1 = Join-Path -Path $PortablePath -ChildPath 'Identity/1.0.0'
        $IdentityV2 = Join-Path -Path $PortablePath -ChildPath 'Identity/2.0.0'
        $Root = Join-Path -Path $PortablePath -ChildPath 'GuidRoot/1.0.0'
        $null = New-Item -ItemType Directory -Path $IdentityV1, $IdentityV2, $Root -Force

        "@{ RootModule = ''; ModuleVersion = '1.0.0'; GUID = '88888888-8888-8888-8888-888888888888' }" | Set-Content -LiteralPath (Join-Path $IdentityV1 'Identity.psd1')
        "@{ RootModule = ''; ModuleVersion = '2.0.0'; GUID = '99999999-9999-9999-9999-999999999999' }" | Set-Content -LiteralPath (Join-Path $IdentityV2 'Identity.psd1')
        "@{ RootModule = ''; ModuleVersion = '1.0.0'; GUID = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'; RequiredModules = @(@{ ModuleName = 'Identity'; GUID = '88888888-8888-8888-8888-888888888888' }) }" | Set-Content -LiteralPath (Join-Path $Root 'GuidRoot.psd1')

        Initialize-ModulePortable -Name GuidRoot -Path $PortablePath -Download

        $Loader = Get-Content -LiteralPath (Join-Path $PortablePath 'GuidRoot.ps1') -Raw
        $Loader | Should -Match 'Identity/1.0.0/Identity.psd1'
        $Loader | Should -Not -Match 'Identity/2.0.0/Identity.psd1'
    }

    It 'backtracks when the highest candidate introduces a dependency cycle' {
        $CycleRootV1 = Join-Path -Path $PortablePath -ChildPath 'CycleRoot/1.0.0'
        $CycleRootV2 = Join-Path -Path $PortablePath -ChildPath 'CycleRoot/2.0.0'
        $CycleDependency = Join-Path -Path $PortablePath -ChildPath 'CycleDependency/1.0.0'
        $null = New-Item -ItemType Directory -Path $CycleRootV1, $CycleRootV2, $CycleDependency -Force

        "@{ RootModule = ''; ModuleVersion = '1.0.0'; GUID = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb' }" | Set-Content -LiteralPath (Join-Path $CycleRootV1 'CycleRoot.psd1')
        "@{ RootModule = ''; ModuleVersion = '2.0.0'; GUID = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'; RequiredModules = @('CycleDependency') }" | Set-Content -LiteralPath (Join-Path $CycleRootV2 'CycleRoot.psd1')
        "@{ RootModule = ''; ModuleVersion = '1.0.0'; GUID = 'cccccccc-cccc-cccc-cccc-cccccccccccc'; RequiredModules = @(@{ ModuleName = 'CycleRoot'; RequiredVersion = '2.0.0' }) }" | Set-Content -LiteralPath (Join-Path $CycleDependency 'CycleDependency.psd1')

        Initialize-ModulePortable -Name CycleRoot -Path $PortablePath -Download

        $Loader = Get-Content -LiteralPath (Join-Path $PortablePath 'CycleRoot.ps1') -Raw
        $Loader | Should -Match 'CycleRoot/1.0.0/CycleRoot.psd1'
        $Loader | Should -Not -Match 'CycleRoot/2.0.0/CycleRoot.psd1'
        $Loader | Should -Not -Match 'CycleDependency/1.0.0/CycleDependency.psd1'
    }

    It 'resolves relative paths from the current PowerShell location' {
        Push-Location -LiteralPath $TestDrive
        try {
            Initialize-ModulePortable -Name Primary -Path '.\Modules' -Download
        } finally {
            Pop-Location
        }

        Test-Path -LiteralPath (Join-Path $PortablePath 'Primary.ps1') | Should -BeTrue
    }
}
