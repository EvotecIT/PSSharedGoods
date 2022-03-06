Import-Module $PSScriptRoot\..\PSsharedGoods.psd1 -Force

Remove-PSRegistry -RegistryPath "HKEY_CURRENT_USER\Tests\Ok\MaybeNot" -Key "LimitBlankPass1wordUse" -WhatIf
Remove-PSRegistry -RegistryPath "HKCU:\Tests\Ok" -WhatIf