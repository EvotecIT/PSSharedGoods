#get-process | Select-Object -First 5 | Format-Stream Name, PriorityClass, HandleCount -List -Stream Output # | Add-Content -Path 'C:\Test.txt'
Get-Process | Select-Object -First 5 | Format-Stream Name, PriorityClass, HandleCount -List -Stream Debug
Get-Process | Select-Object -First 5 | Format-Stream Name, PriorityClass, HandleCount -Stream Output | Add-Content -Path 'C:\Test.txt'

#get-process | Select-Object -First 5 | Format-TableVerbose Name, PriorityClass, HandleCount #, FileVersion, Handles, Id, Si , StartInfo, MainModule
Get-Process | Select-Object -First 5 | Format-Stream Name, PriorityClass, HandleCount , FileVersion, Handles, Id, Si , StartInfo, MainModule -Stream 'Warning'
Get-Process | Select-Object -First 5 | Format-Stream Id, Si , StartInfo, MainModule -Stream Information

Get-Process | Select-Object -First 5 | Format-Stream *

Get-Process | Select-Object -First 5 | Format-Stream * -HideTableHeaders # Id, Si , StartInfo, MainModule

Get-Process | Select-Object -First 5 | Format-Stream * -AlignRight  # Id, Si , StartInfo, MainModule

$Process = Get-Process | Select-Object -First 5
Format-Stream -InputObject $Process -ExcludeProperty Company, CPU -ColumnHeaderSize 15