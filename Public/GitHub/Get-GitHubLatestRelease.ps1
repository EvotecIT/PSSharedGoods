function Get-GitHubLatestRelease {
    <#
    .SYNOPSIS
    Gets one or more releases from GitHub repository

    .DESCRIPTION
    Gets one or more releases from GitHub repository

    .PARAMETER Url
    Url to github repository

    .EXAMPLE
    Get-GitHubLatestRelease -Url "https://api.github.com1/repos/evotecit/Testimo/releases" | Format-Table

    .NOTES
    General notes
    #>
    [CmdLetBinding()]
    param(
        [parameter(Mandatory)][alias('ReleasesUrl')][uri] $Url
    )
    $ProgressPreference = 'SilentlyContinue'

    $Responds = Test-Connection -ComputerName $URl.Host -Quiet -Count 1
    if ($Responds) {
        Try {
            [Array] $JsonOutput = (Invoke-WebRequest -Uri $Url -ErrorAction Stop | ConvertFrom-Json)
            foreach ($JsonContent in $JsonOutput) {
                [PSCustomObject] @{
                    PublishDate = [DateTime]  $JsonContent.published_at
                    CreatedDate = [DateTime] $JsonContent.created_at
                    PreRelease  = [bool] $JsonContent.prerelease
                    Version     = [version] ($JsonContent.name -replace 'v', '')
                    Tag         = $JsonContent.tag_name
                    Branch      = $JsonContent.target_commitish
                    Errors      = ''
                }
            }
        } catch {
            [PSCustomObject] @{
                PublishDate = $null
                CreatedDate = $null
                PreRelease  = $null
                Version     = $null
                Tag         = $null
                Branch      = $null
                Errors      = $_.Exception.Message
            }
        }
    } else {
        [PSCustomObject] @{
            PublishDate = $null
            CreatedDate = $null
            PreRelease  = $null
            Version     = $null
            Tag         = $null
            Branch      = $null
            Errors      = "No connection (ping) to $($Url.Host)"
        }
    }
    $ProgressPreference = 'Continue'
}