Clear-Host
Import-Module 'C:\Support\GitHub\PSPublishModule\PSPublishModule.psm1' -Force


$Configuration = @{
    Information = @{
        ModuleName        = 'PSSharedGoods'
        DirectoryProjects = 'C:\Support\GitHub'
        Manifest          = @{
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
            RequiredModules      = @(
                @{ ModuleName = 'PSWriteColor'; ModuleVersion = 'Latest'; Guid = '0b0ba5c5-ec85-4c2b-a718-874e55a8bc3f' }
                @{ ModuleName = 'Connectimo'; ModuleVersion = 'Latest'; Guid = 'e4f4f8a6-473e-4ba5-8166-480658c11421' }
            )
        }
    }
    Options     = @{
        Merge             = @{
            Sort           = 'None'
            FormatCodePSM1 = @{
                Enabled           = $true
                RemoveComments    = $true
                FormatterSettings = @{
                    IncludeRules = @(
                        'PSPlaceOpenBrace',
                        'PSPlaceCloseBrace',
                        'PSUseConsistentWhitespace',
                        'PSUseConsistentIndentation',
                        'PSAlignAssignmentStatement',
                        'PSUseCorrectCasing'
                    )

                    Rules        = @{
                        PSPlaceOpenBrace           = @{
                            Enable             = $true
                            OnSameLine         = $true
                            NewLineAfter       = $true
                            IgnoreOneLineBlock = $true
                        }

                        PSPlaceCloseBrace          = @{
                            Enable             = $true
                            NewLineAfter       = $false
                            IgnoreOneLineBlock = $true
                            NoEmptyLineBefore  = $false
                        }

                        PSUseConsistentIndentation = @{
                            Enable              = $true
                            Kind                = 'space'
                            PipelineIndentation = 'IncreaseIndentationAfterEveryPipeline'
                            IndentationSize     = 4
                        }

                        PSUseConsistentWhitespace  = @{
                            Enable          = $true
                            CheckInnerBrace = $true
                            CheckOpenBrace  = $true
                            CheckOpenParen  = $true
                            CheckOperator   = $true
                            CheckPipe       = $true
                            CheckSeparator  = $true
                        }

                        PSAlignAssignmentStatement = @{
                            Enable         = $true
                            CheckHashtable = $true
                        }

                        PSUseCorrectCasing         = @{
                            Enable = $true
                        }
                    }
                }
            }
            FormatCodePSD1 = @{
                Enabled        = $true
                RemoveComments = $false
            }
            Integrate      = @{
                ApprovedModules = 'PSWriteColor', 'Connectimo', 'PSUnifi', 'PSWebToolbox', 'PSMyPassword'
            }
        }
        Standard          = @{
            FormatCodePSM1 = @{

            }
            FormatCodePSD1 = @{
                Enabled = $true
                #RemoveComments = $true
            }
        }
        PowerShellGallery = @{
            ApiKey   = 'C:\Support\Important\PowerShellGalleryAPI.txt'
            FromFile = $true
        }
        GitHub            = @{
            ApiKey   = 'C:\Support\Important\GithubAPI.txt'
            FromFile = $true
            UserName = 'EvotecIT'
            #RepositoryName = 'PSPublishModule' # not required, uses project name
        }
        Documentation     = @{
            Path       = 'Docs'
            PathReadme = 'Docs\Readme.md'
        }
    }
    Steps       = @{
        BuildModule        = @{  # requires Enable to be on to process all of that
            Enable           = $true
            DeleteBefore     = $false
            Merge            = $true
            MergeMissing     = $false
            SignMerged       = $true
            Releases         = $true
            ReleasesUnpacked = $false
            RefreshPSD1Only  = $false
        }
        BuildDocumentation = $false
        ImportModules      = @{
            Self            = $true
            RequiredModules = $false
            Verbose         = $false
        }
        PublishModule      = @{  # requires Enable to be on to process all of that
            Enabled      = $false
            Prerelease   = ''
            RequireForce = $false
            GitHub       = $false
        }
    }
}

New-PrepareModule -Configuration $Configuration