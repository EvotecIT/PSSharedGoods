function Get-ObjectCount {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)][Object]$Object
    )
    return $($Object | Measure-Object).Count
}