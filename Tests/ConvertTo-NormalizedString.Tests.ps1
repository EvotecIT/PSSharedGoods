Describe -Name 'Testing ConvertTo-NormalizedString' {
    It 'Different strings' {
        "äöüß" | ConvertTo-NormalizedString | Should -Be "aeoeuess"
        "Yağız Barın" | ConvertTo-NormalizedString | Should -Be "Yagiz Barin"
        ConvertTo-NormalizedString -String "café" | Should -Be "cafe"
        "café" | ConvertTo-NormalizedString | Should -Be "cafe"
        'Helène' | ConvertTo-NormalizedString | Should -Be "Helene"
        "Przemysław Kłys and Helène" | ConvertTo-NormalizedString | Should -Be "Przemyslaw Klys and Helene"
        "kłys" | ConvertTo-NormalizedString | Should -Be "klys"
        "ąęćśł" | ConvertTo-NormalizedString | Should -Be "aecsl"
        "Michael Roßbach" | ConvertTo-NormalizedString | Should -Be "Michael Rossbach"
        "öüóőúéáűí" | ConvertTo-NormalizedString | Should -Be "oeueooueaui"
        "ß" | ConvertTo-NormalizedString | Should -Be "ss"
        "Un été de Raphaël" | ConvertTo-NormalizedString | Should -Be "Un ete de Raphael"
        ("äâûê", "éèà", "ùçä") | ConvertTo-NormalizedString | Should -Be "aeaue", "eea", "ucae"
        "Fore ðære mærðe…" | ConvertTo-NormalizedString | Should -Be "Fore daere maerde..."
        "ABC-abc-ČŠŽ-čšž" | ConvertTo-NormalizedString | Should -Be "ABC-abc-CSZ-csz"
        'ç' | ConvertTo-NormalizedString | Should -Be 'c'
        'Ç' | ConvertTo-NormalizedString | Should -Be 'C'
        "Æ×Þ°±ß…" | ConvertTo-NormalizedString | Should -Be "aeXthopss..."
    }
}