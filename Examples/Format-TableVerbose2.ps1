get-process | Select-Object -First 5 | Format-Stream Name, PriorityClass, HandleCount -Stream Output | Add-Content -Path 'C:\Test.txt'

#get-process | Select-Object -First 5 | Format-TableVerbose Name, PriorityClass, HandleCount #, FileVersion, Handles, Id, Si , StartInfo, MainModule
get-process | Select-Object -First 5 | Format-Stream Name, PriorityClass, HandleCount , FileVersion, Handles, Id, Si , StartInfo, MainModule -Stream 'Warning'
get-process | Select-Object -First 5 | Format-Stream Id, Si , StartInfo, MainModule -Stream Information

get-process | Select-Object -First 5 | Format-Stream *

get-process | Select-Object -First 5 | Format-Stream * -HideTableHeaders # Id, Si , StartInfo, MainModule

get-process | Select-Object -First 5 | Format-Stream * -AlignRight  # Id, Si , StartInfo, MainModule

#get-aduser -Filter * | Format-TableVerbose

$Process = get-process | Select-Object -First 5
Format-Stream -InputObject $Process -ExcludeProperty Company, CPU -ColumnHeaderSize 15


Format-Table