function Show-TableVisualization {
    <#
    .SYNOPSIS
    Displays a table visualization of the input object.

    .DESCRIPTION
    The Show-TableVisualization function displays a table visualization of the input object using Format-Table. It also provides additional information about the table data.

    .PARAMETER Object
    Specifies the input object to be visualized as a table.

    .EXAMPLE
    PS C:\> Get-Process | Show-TableVisualization
    Displays a table visualization of the processes retrieved by Get-Process.

    .EXAMPLE
    PS C:\> $data = Get-Service | Where-Object { $_.Status -eq 'Running' } | Select-Object Name, DisplayName, Status
    PS C:\> $data | Show-TableVisualization
    Displays a table visualization of the selected service data.

    #>
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)] $Object
    )
    if ($Color) { Write-Color "[i] This is how table looks like in Format-Table" -Color Yellow }
    Write-Verbose '[i] This is how table looks like in Format-Table'
    $Object | Format-Table -AutoSize
    $Data = Format-PSTable $Object #-Verbose

    Write-Verbose "[i] Rows Count $($Data.Count) Column Count $($Data[0].Count)"
    $RowNr = 0
    if ($Color) { Write-Color "[i] Presenting table after conversion" -Color Yellow }
    foreach ($Row in $Data) {
        $ColumnNr = 0
        foreach ($Column in $Row) {
            Write-Verbose "Row: $RowNr Column: $ColumnNr Data: $Column"
            $ColumnNr++
        }
        $RowNr++
    }
}