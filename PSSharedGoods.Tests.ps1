$PSVersionTable.PSVersion

$ModuleName = (Get-ChildItem $PSScriptRoot\*.psd1).BaseName

if ($null -eq (Get-Module -ListAvailable pester)) {
    Write-Warning "$ModuleName - Downloading Pester from PSGallery"
    Install-Module -Name Pester -Repository PSGallery -Force -SkipPublisherCheck
}

Import-Module $PSScriptRoot\*.psd1 -Force

$result = Invoke-Pester -Script $PSScriptRoot\Tests -Verbose -EnableExit

if ($result.FailedCount -gt 0) {
    throw "$($result.FailedCount) tests failed."
}