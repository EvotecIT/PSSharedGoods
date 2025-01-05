Import-Module .\PSSharedGoods.psd1 -Force

Remove-FileItem -Paths "C:\Temp\New folder" -DeleteMethod RecycleBin -Recursive -Passthru #-SkipFolder