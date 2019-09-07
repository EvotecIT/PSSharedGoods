function Initialize-ModulePortable {
    [CmdletBinding()]
    param(
        [alias('ModuleName')][string] $Name,
        [string] $Path = $PSScriptRoot,
        [switch] $Download
    )
    if (-not $Name) {
        Write-Warning "Initialize-ModulePortable - Module name not given. Terminating."
        return
    }
    if ($Download) {
        try {
            Save-Module -Name $Name -LiteralPath $Path -WarningVariable WarningData -WarningAction SilentlyContinue -ErrorAction Stop
        } catch {
            $ErrorMessage = $_.Exception.Message

            if ($WarningData) {
                Write-Warning "Initialize-ModulePortable - $WarningData"
            }
            Write-Warning "Initialize-ModulePortable - Error $ErrorMessage"
            return
        }
    }

    $ListModules = Get-ChildItem -LiteralPath $Path -Filter '*.psd1' -Recurse -ErrorAction SilentlyContinue
    foreach ($Module in $ListModules.FullName) {
        Import-Module -Name $Module -Force -ErrorAction SilentlyContinue
    }
}