#Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue -Recurse )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue -Recurse )
$Assembly = @( Get-ChildItem -Path $PSScriptRoot\Lib\*.dll -ErrorAction SilentlyContinue -Recurse )

#Dot source the files
Foreach ($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    } Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}
Foreach ($import in @($Assembly)) {
    Try {
        Add-Type -Path $import.fullname
    } Catch {
        Write-Error -Message "Failed to import DLL $($import.fullname): $_"
    }
}

$FunctionsToExport = 'Send-EmailNew', 'Connect-Tenant1', 'Add-WinADUserGroups',
'Get-WinADUserSnapshot', 'Remove-WinADUserGroups',
'Set-WinADGroupSynchronization', 'Set-WinADUserFields',
'Set-WinADUserSettingGAL', 'Set-WinADUserStatus',
'Add-PropertyToList', 'New-UserAdd', 'Set-SpecUser',
'Set-WinAzureADUserLicense', 'Set-WinAzureADUserStatus',
'Connect-WinAzure', 'Connect-WinAzureAD', 'Connect-WinExchange',
'Connect-WinService', 'Connect-WinTeams', 'Disconnect-WinAzure',
'Disconnect-WinAzureAD', 'Disconnect-WinExchange',
'Disconnect-WinTeams', 'Get-MyIP', 'Request-Credentials',
'Convert-ExchangeEmail', 'Convert-ExchangeItems',
'Convert-ExchangeSize', 'Convert-KeyToKeyValue', 'Convert-Size',
'Convert-TimeToDays', 'Convert-ToDateTime', 'Convert-ToTimeSpan',
'Convert-TwoArraysIntoOne', 'Convert-UAC', 'ConvertFrom-SID',
'ConvertTo-ImmutableID', 'Find-DatesCurrentDayMinusDayX',
'Find-DatesCurrentDayMinuxDaysX', 'Find-DatesCurrentHour',
'Find-DatesDayPrevious', 'Find-DatesDayToday',
'Find-DatesMonthCurrent', 'Find-DatesMonthPast', 'Find-DatesPastHour',
'Find-DatesPastWeek', 'Find-DatesQuarterCurrent',
'Find-DatesQuarterLast', 'Set-DnsServerIpAddress', 'Get-HTML',
'Send-Email', 'Set-EmailBody', 'Set-EmailBodyPreparedTable',
'Set-EmailBodyReplacement', 'Set-EmailBodyReplacementTable',
'Set-EmailFormatting', 'Set-EmailHead', 'Set-EmailReportBranding',
'Set-EmailWordReplacements', 'Set-EmailWordReplacementsHash',
'Get-FileInformation', 'Get-FilesInFolder', 'Get-FileSize',
'Get-PathSeparator', 'Get-PathTemporary', 'Add-ToArray',
'Add-ToArrayAdvanced', 'Add-ToHashTable', 'Format-PSTable',
'Format-PSTableConvertType1', 'Format-PSTableConvertType2',
'Format-PSTableConvertType3', 'Format-TransposeTable',
'Get-HashMaxValue', 'Get-MimeType', 'Get-ObjectCount', 'Get-ObjectData',
'Get-ObjectKeys', 'Get-ObjectProperties',
'Get-ObjectPropertiesAdvanced', 'Get-ObjectTitles', 'Get-ObjectType',
'Get-Types', 'Merge-Objects', 'New-ArrayList',
'Remove-DuplicateObjects', 'Remove-FromArray',
'Remove-ObjectsExistingInTarget', 'Rename-UserValuesFromHash',
'Split-Array', 'Find-MyProgramData', 'Start-MyProgram',
'Get-RandomCharacters', 'Get-RandomPassword', 'Get-RandomStringName',
'Get-CommandInfo', 'New-Runspace', 'Start-Runspace', 'Stop-Runspace',
'Get-SqlQueryColumnInformation', 'New-SqlQuery',
'New-SqlQueryAlterTable', 'New-SqlQueryCreateTable',
'New-SqlTableMapping', 'Send-SqlInsert', 'Find-TypesNeeded',
'Get-ModulesAvailability', 'Search-Command',
'Test-AvailabilityCommands', 'Test-ComputerAvailability',
'Test-ConfigurationCredentials', 'Test-ForestConnectivity',
'Test-Key', 'Test-ModuleAvailability', 'Test-Port', 'Test-WinRM',
'Get-TimeZoneAdvanced', 'Get-TimeZoneLegacy', 'Start-TimeLog',
'Stop-TimeLog', 'Show-Array', 'Show-DataInVerbose',
'Show-TableVisualization', 'Save-XML', 'Set-XML', 'Format-Stream','Format-ToTitleCase'

Export-ModuleMember -Function $FunctionsToExport -Alias 'FTV','Format-TableVerbose','Format-TableDebug','Format-TableInformation','Format-TableWarning'

[string] $ManifestFile = '{0}.psd1' -f (Get-Item $PSCommandPath).BaseName;
$ManifestPathAndFile = Join-Path -Path $PSScriptRoot -ChildPath $ManifestFile;
if ( Test-Path -Path $ManifestPathAndFile) {
    $Manifest = (Get-Content -raw $ManifestPathAndFile) | iex;
    foreach ( $ScriptToProcess in $Manifest.ScriptsToProcess) {
        $ModuleToRemove = (Get-Item (Join-Path -Path $PSScriptRoot -ChildPath $ScriptToProcess)).BaseName;
        if (Get-Module $ModuleToRemove) {
            Remove-Module $ModuleToRemove;
        }
    }
}