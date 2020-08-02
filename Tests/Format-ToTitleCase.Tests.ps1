Describe -Name 'Testing Format-ToTitleCase' {
    It 'Test very long sentence and removee some special chars and spaces' {
        $String = Format-ToTitleCase -Text "This is my thing: That - No I don't want all chars" -RemoveWhiteSpace -RemoveChar ',', '-', "'", '\(', '\)', ':'
        $String | Should -BeExactly 'ThisIsMyThingThatNoIDontWantAllChars'
    }
    It 'Test long sentance and remove spaces' {
        Format-ToTitleCase -Text 'This is my thing' -RemoveWhiteSpace | Should -BeExactly 'ThisIsMyThing'
    }
    It 'Test pipeline with 2 strings' {
        $String = 'me i feel', 'not feel' | Format-ToTitleCase
        $String[0] | Should -BeExactly 'Me I Feel'
        $String[1] | Should -BeExactly 'Not Feel'
    }
    It 'Testing long string' {
        $String = 'me i feel good' | Format-ToTitleCase
        $String | Should -BeExactly 'Me I Feel Good'
    }
    It 'Testing short string' {
        Format-ToTitleCase 'MerRe' | Should -BeExactly 'Merre'
    }

}