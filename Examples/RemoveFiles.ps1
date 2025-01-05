Import-Module .\PSSharedGoods.psd1 -Force

Remove-ItemAlternative -Paths "C:\Temp\New folder" -DeleteMethod RecycleBin -Recursive -Passthru #-SkipFolder