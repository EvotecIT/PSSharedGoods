function Get-GitHubVersion {
    <#
    .SYNOPSIS
    Get the latest version of a GitHub repository and compare with local version

    .DESCRIPTION
    Get the latest version of a GitHub repository and compare with local version

    .PARAMETER Cmdlet
    Cmdlet to find module for

    .PARAMETER RepositoryOwner
    Repository owner

    .PARAMETER RepositoryName
    Repository name

    .EXAMPLE
    Get-GitHubVersion -Cmdlet 'Start-DelegationModel' -RepositoryOwner 'evotecit' -RepositoryName 'DelegationModel'

    .NOTES
    General notes
    #>
    [cmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Cmdlet,
        [Parameter(Mandatory)][string] $RepositoryOwner,
        [Parameter(Mandatory)][string] $RepositoryName
    )
    $App = Get-Command -Name $Cmdlet -ErrorAction SilentlyContinue
    if ($App) {
        [Array] $GitHubReleases = (Get-GitHubLatestRelease -Url "https://api.github.com/repos/$RepositoryOwner/$RepositoryName/releases" -Verbose:$false)
        $LatestVersion = $GitHubReleases[0]
        if (-not $LatestVersion.Errors) {
            if ($App.Version -eq $LatestVersion.Version) {
                "Current/Latest: $($LatestVersion.Version) at $($LatestVersion.PublishDate)"
            } elseif ($App.Version -lt $LatestVersion.Version) {
                "Current: $($App.Version), Published: $($LatestVersion.Version) at $($LatestVersion.PublishDate). Update?"
            } elseif ($App.Version -gt $LatestVersion.Version) {
                "Current: $($App.Version), Published: $($LatestVersion.Version) at $($LatestVersion.PublishDate). Lucky you!"
            }
        } else {
            "Current: $($App.Version)"
        }
    }
}