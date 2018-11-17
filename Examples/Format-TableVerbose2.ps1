get-process | Select-Object -First 5 | Format-Table Name, PriorityClass, HandleCount #-AutoSize
#get-process | Select-Object -First 5 | Format-TableVerbose Name, PriorityClass, HandleCount #, FileVersion, Handles, Id, Si , StartInfo, MainModule
get-process | Select-Object -First 5 | Format-TableVerbose Name, PriorityClass, HandleCount , FileVersion, Handles, Id, Si , StartInfo, MainModule
get-process | Select-Object -First 5 | Format-TableVerbose Id, Si , StartInfo, MainModule

get-process | Select-Object -First 5 | Format-TableVerbose *

get-process | Select-Object -First 5 | Format-Table * # Id, Si , StartInfo, MainModule

#get-aduser -Filter * | Format-TableVerbose
Format-TableVerbose


Format-Table