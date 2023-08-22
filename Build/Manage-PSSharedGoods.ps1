Import-Module "PSPublishModule" -Force

Invoke-ModuleBuild -ModuleName 'PSSharedGoods' {
    # Usual defaults as per standard module
    $Manifest = @{
        # Version number of this module.
        ModuleVersion        = '0.0.X'
        # Supported PSEditions
        CompatiblePSEditions = @('Desktop', 'Core')
        # ID used to uniquely identify this module
        GUID                 = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
        # Author of this module
        Author               = 'Przemyslaw Klys'
        # Company or vendor of this module
        CompanyName          = 'Evotec'
        # Copyright statement for this module
        Copyright            = "(c) 2011 - $((Get-Date).Year) Przemyslaw Klys @ Evotec. All rights reserved."
        # Description of the functionality provided by this module
        Description          = 'Module covering functions that are shared within multiple projects'
        # Minimum version of the Windows PowerShell engine required by this module
        PowerShellVersion    = '5.1'
        # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
        # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
        Tags                 = @('Windows', 'MacOS', 'Linux', 'Shared', 'Useful', 'Email', 'Format', 'Azure', 'ActiveDirectory')
        IconUri              = 'https://evotec.xyz/wp-content/uploads/2018/10/PSSharedGoods-Alternative.png'
        ProjectUri           = 'https://github.com/EvotecIT/PSSharedGoods'
    }
    New-ConfigurationManifest @Manifest

    New-ConfigurationModule -Type RequiredModule -Name 'PSWriteColor' -Guid Auto -Version Latest
    #New-ConfigurationModule -Type ExternalModule -Name 'Microsoft.PowerShell.Utility', 'Microsoft.PowerShell.Management','Microsoft.PowerShell.Security'
    New-ConfigurationModule -Type ApprovedModule -Name 'PSWriteColor', 'Connectimo', 'PSUnifi', 'PSWebToolbox', 'PSMyPassword'

    New-ConfigurationModuleSkip -IgnoreModuleName @(
        # this are builtin into PowerShell, so not critical
        'Microsoft.PowerShell.Management'
        'Microsoft.PowerShell.Security'
        'Microsoft.PowerShell.Utility'
        'Microsoft.WSMan.Management'
        'NetConnection'
        'NetSecurity'
        'NetTCPIP'
        'powershellget'
        'SmbShare'
        'ServerManager'
        'ScheduledTasks'
        'ActiveDirectory'
        'CimCmdlets'
        'DnsClient'
    ) -IgnoreFunctionName 'Select-Unique', 'Compare-TwoArrays', 'Invoke-DbaQuery', 'Get-RequiredModule' # those functions are internal within private function

    $ConfigurationFormat = [ordered] @{
        RemoveComments                              = $true
        RemoveEmptyLines                            = $true

        PlaceOpenBraceEnable                        = $true
        PlaceOpenBraceOnSameLine                    = $true
        PlaceOpenBraceNewLineAfter                  = $true
        PlaceOpenBraceIgnoreOneLineBlock            = $false

        PlaceCloseBraceEnable                       = $true
        PlaceCloseBraceNewLineAfter                 = $true
        PlaceCloseBraceIgnoreOneLineBlock           = $false
        PlaceCloseBraceNoEmptyLineBefore            = $true

        UseConsistentIndentationEnable              = $true
        UseConsistentIndentationKind                = 'space'
        UseConsistentIndentationPipelineIndentation = 'IncreaseIndentationAfterEveryPipeline'
        UseConsistentIndentationIndentationSize     = 4

        UseConsistentWhitespaceEnable               = $true
        UseConsistentWhitespaceCheckInnerBrace      = $true
        UseConsistentWhitespaceCheckOpenBrace       = $true
        UseConsistentWhitespaceCheckOpenParen       = $true
        UseConsistentWhitespaceCheckOperator        = $true
        UseConsistentWhitespaceCheckPipe            = $true
        UseConsistentWhitespaceCheckSeparator       = $true

        AlignAssignmentStatementEnable              = $true
        AlignAssignmentStatementCheckHashtable      = $true

        UseCorrectCasingEnable                      = $true
    }
    # format PSD1 and PSM1 files when merging into a single file
    # enable formatting is not required as Configuration is provided
    New-ConfigurationFormat -ApplyTo 'OnMergePSM1', 'OnMergePSD1' -Sort None @ConfigurationFormat
    # format PSD1 and PSM1 files within the module
    # enable formatting is required to make sure that formatting is applied (with default settings)
    New-ConfigurationFormat -ApplyTo 'DefaultPSD1', 'DefaultPSM1' -EnableFormatting -Sort None
    # when creating PSD1 use special style without comments and with only required parameters
    New-ConfigurationFormat -ApplyTo 'DefaultPSD1', 'OnMergePSD1' -PSD1Style 'Minimal'
    # configuration for documentation, at the same time it enables documentation processing
    New-ConfigurationDocumentation -Enable:$false -StartClean -UpdateWhenNew -PathReadme 'Docs\Readme.md' -Path 'Docs'

    New-ConfigurationImportModule -ImportSelf

    New-ConfigurationBuild -Enable:$true -SignModule -MergeModuleOnBuild -MergeFunctionsFromApprovedModules -CertificateThumbprint '483292C9E317AA13B07BB7A96AE9D1A5ED9E7703'

    New-ConfigurationTest -TestsPath "$PSScriptRoot\..\Tests" -Enable

    New-ConfigurationArtefact -Type Unpacked -Enable -Path "$PSScriptRoot\..\Artefacts\Unpacked" -AddRequiredModules
    New-ConfigurationArtefact -Type Packed -Enable -Path "$PSScriptRoot\..\Artefacts\Packed" -ArtefactName '<ModuleName>.v<ModuleVersion>.zip'

    # options for publishing to github/psgallery
    #New-ConfigurationPublish -Type PowerShellGallery -FilePath 'C:\Support\Important\PowerShellGalleryAPI.txt' -Enabled:$true
    #New-ConfigurationPublish -Type GitHub -FilePath 'C:\Support\Important\GitHubAPI.txt' -UserName 'EvotecIT' -Enabled:$true
} -ExitCode