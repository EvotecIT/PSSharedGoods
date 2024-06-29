Describe -Name 'Testing Format-TransposeTable' {
    It 'Object conversion' {
        $T = [PSCustomObject] @{
            Test   = 1
            Test2  = 7
            Ole    = 'bole'
            Trolle = 'A'
            Alle   = 'sd'
        }
        $Output = Format-TransposeTable -Object @($T)
        $Output[0].Name | Should -BeExactly 'Test'
        $Output[1].Name | Should -BeExactly 'Test2'
        $Output[2].Name | Should -BeExactly 'Ole'
        $Output[3].Name | Should -BeExactly 'Trolle'
        $Output[4].Name | Should -BeExactly 'Alle'
        $Output[0].'Object 0' | Should -BeExactly 1
        $Output[1].'Object 0' | Should -BeExactly 7
        $Output[2].'Object 0' | Should -BeExactly 'bole'
        $Output[3].'Object 0' | Should -BeExactly 'A'
        $Output[4].'Object 0' | Should -BeExactly 'sd'
    }
    It 'Object conversion - Legacy' {
        $T = [PSCustomObject] @{
            Test   = 1
            Test2  = 7
            Ole    = 'bole'
            Trolle = 'A'
            Alle   = 'sd'
        }
        $Output = Format-TransposeTable -Object @($T) -Legacy
        $Output.Test | Should -BeExactly 1
        $Output.Test2 | Should -BeExactly 7
        $Output.Ole | Should -BeExactly 'bole'
        $Output.Trolle | Should -BeExactly 'A'
        $Output.Alle | Should -BeExactly 'sd'
    }
    It 'Object conversion - Property' {
        $T = [PSCustomObject] @{
            Test       = 1
            Test2      = 7
            ServerName = 'Server 1'
            Trolle     = 'A'
            Alle       = 'sd'
        }
        $Output = Format-TransposeTable -Object @($T) -Property 'ServerName'
        $Output[0].Name | Should -BeExactly 'Test'
        $Output[1].Name | Should -BeExactly 'Test2'
        $Output[2].Name | Should -BeExactly 'ServerName'
        $Output[3].Name | Should -BeExactly 'Trolle'
        $Output[4].Name | Should -BeExactly 'Alle'
        $Output[0].'Server 1' | Should -BeExactly 1
        $Output[1].'Server 1' | Should -BeExactly 7
        $Output[2].'Server 1' | Should -BeExactly 'Server 1'
        $Output[3].'Server 1' | Should -BeExactly 'A'
        $Output[4].'Server 1' | Should -BeExactly 'sd'
    }

    It 'Multiple Object conversion - Property' {
        $T = [PSCustomObject] @{
            Test       = 1
            Test2      = 7
            ServerName = 'Server 1'
            Trolle     = 'A'
            Alle       = 'sd'
        }
        $T2 = [PSCustomObject] @{
            Test       = 2
            Test2      = 8
            ServerName = 'Server 2'
            Trolle     = 'A'
            Alle       = 'sd'
        }
        $Output = Format-TransposeTable -Object @($T, $T2) -Property 'ServerName'
        $Output[0].Name | Should -BeExactly 'Test'
        $Output[1].Name | Should -BeExactly 'Test2'
        $Output[2].Name | Should -BeExactly 'ServerName'
        $Output[3].Name | Should -BeExactly 'Trolle'
        $Output[4].Name | Should -BeExactly 'Alle'
        $Output[0].'Server 1' | Should -BeExactly 1
        $Output[1].'Server 1' | Should -BeExactly 7
        $Output[2].'Server 1' | Should -BeExactly 'Server 1'
        $Output[3].'Server 1' | Should -BeExactly 'A'
        $Output[4].'Server 1' | Should -BeExactly 'sd'

        $Output[0].'Server 2' | Should -BeExactly 2
        $Output[1].'Server 2' | Should -BeExactly 8
        $Output[2].'Server 2' | Should -BeExactly 'Server 2'
        $Output[3].'Server 2' | Should -BeExactly 'A'
        $Output[4].'Server 2' | Should -BeExactly 'sd'

    }
}