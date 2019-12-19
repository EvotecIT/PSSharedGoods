function Get-GitHubLatestRelease {
    [CmdLetBinding()]
    param(
        [alias('ReleasesUrl')][uri] $Url
    )
    Try {
        $JsonContent = (Invoke-WebRequest -Uri $Url -ErrorAction Stop | ConvertFrom-Json)
        [PSCustomObject] @{
            PublishDate = [DateTime]  $JsonContent.published_at
            CreatedDate = [DateTime] $JsonContent.created_at
            PreRelease  = [bool] $JsonContent.prerelease
            Version     = [version] ($JsonContent.name -replace 'v', '')
            Tag         = $JsonContent.tag_name
            Branch      = $JsonContent.target_commitish
            Errors      = ''
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
}