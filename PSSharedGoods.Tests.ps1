$ModuleName = (Get-ChildItem $PSScriptRoot\*.psd1).BaseName
$PrimaryModule = Get-ChildItem -Path $PSScriptRoot -Filter '*.psd1' -Recurse -ErrorAction SilentlyContinue -Depth 1
if (-not $PrimaryModule) {
    throw "Path $PSScriptRoot doesn't contain PSD1 files. Failing tests."
}
if ($PrimaryModule.Count -ne 1) {
    throw 'More than one PSD1 files detected. Failing tests.'
}
$PSDInformation = Import-PowerShellDataFile -Path $PrimaryModule.FullName
$RequiredModules = @(
    'Pester'
    'PSWriteColor'
    if ($PSDInformation.RequiredModules) {
        $PSDInformation.RequiredModules
    }
)
foreach ($Module in $RequiredModules) {
    if ($Module -is [System.Collections.IDictionary]) {
        $Exists = Get-Module -ListAvailable -Name $Module.ModuleName
        if (-not $Exists) {
            Write-Warning "$ModuleName - Downloading $($Module.ModuleName) from PSGallery"
            Install-Module -Name $Module.ModuleName -Force -SkipPublisherCheck
        }
    } else {
        if ($Module -eq 'Pester') {
            $Exists = Get-Module -ListAvailable -Name Pester -ErrorAction SilentlyContinue |
                Where-Object Version -ge ([version] '5.0.0')
        } else {
            $Exists = Get-Module -ListAvailable -Name $Module -ErrorAction SilentlyContinue
        }
        if (-not $Exists) {
            if ($Module -eq 'Pester') {
                Install-Module -Name Pester -MinimumVersion 5.0.0 -Force -SkipPublisherCheck
            } else {
                Install-Module -Name $Module -Force -SkipPublisherCheck
            }
        }
    }
}

Write-Color 'ModuleName: ', $ModuleName, ' Version: ', $PSDInformation.ModuleVersion -Color Yellow, Green, Yellow, Green -LinesBefore 2
Write-Color 'PowerShell Version: ', $PSVersionTable.PSVersion -Color Yellow, Green
Write-Color 'PowerShell Edition: ', $PSVersionTable.PSEdition -Color Yellow, Green
Write-Color 'Required modules: ' -Color Yellow
foreach ($Module in $PSDInformation.RequiredModules) {
    if ($Module -is [System.Collections.IDictionary]) {
        Write-Color '   [>] ', $Module.ModuleName, ' Version: ', $Module.ModuleVersion -Color Yellow, Green, Yellow, Green
    } else {
        Write-Color '   [>] ', $Module -Color Yellow, Green
    }
}
Write-Color

Import-Module $PSScriptRoot\*.psd1 -Force
Import-Module Pester -MinimumVersion 5.0.0 -Force
$configuration = [PesterConfiguration]::Default
$configuration.Run.Path = "$PSScriptRoot\Tests"
$configuration.Run.PassThru = $true
$configuration.Output.Verbosity = 'Detailed'
$result = Invoke-Pester -Configuration $configuration

if ($result.Result -ne 'Passed' -or $result.FailedCount -gt 0) {
    throw "Pester run failed with result '$($result.Result)' and $($result.FailedCount) failed tests."
}
