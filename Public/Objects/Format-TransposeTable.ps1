function Format-TransposeTable {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] [object[]]$Object,
        [ValidateSet("ASC", "DESC", "NONE")][String] $Sort = 'NONE'
    )
    begin { $i = 0; }

    process {
        foreach ($myObject in $Object) {
            if ($myObject.GetType().Name -eq 'hashtable' -or $myObject.GetType().Name -eq 'OrderedDictionary') {
                #Write-Verbose "Format-TransposeTable - Converting HashTable/OrderedDictionary to PSCustomObject - $($myObject.GetType().Name)"
                $output = New-Object -TypeName PsObject;
                Add-Member -InputObject $output -MemberType ScriptMethod -Name AddNote -Value {
                    Add-Member -InputObject $this -MemberType NoteProperty -Name $args[0] -Value $args[1];
                };
                if ($Sort -eq 'ASC') {
                    $myObject.Keys | Sort-Object -Descending:$false | % { $output.AddNote($_, $myObject.$_); }
                } elseif ($Sort -eq 'DESC') {
                    $myObject.Keys | Sort-Object -Descending:$true | % { $output.AddNote($_, $myObject.$_); }
                } else {
                    $myObject.Keys | % { $output.AddNote($_, $myObject.$_); }
                }
                $output;
            } else {
                #Write-Verbose "Format-TransposeTable - Converting PSCustomObject to HashTable/OrderedDictionary - $($myObject.GetType().Name)"
                # Write-Warning "Index $i is not of type [hashtable]";
                $output = [ordered] @{};
                $myObject | Get-Member -MemberType *Property | % {
                    $output.($_.name) = $myObject.($_.name);
                }
                $output

            }
            $i += 1;
        }
    }
}
