function Copy-Dictionary {
    <#
    .SYNOPSIS
    Copies dictionary/hashtable

    .DESCRIPTION
    Copies dictionary uusing PS Serializer. Replaces usage of BinnaryFormatter due to no support in PS 7.4

    .PARAMETER Dictionary
    Dictionary to copy

    .EXAMPLE
    $Test = [ordered] @{
        Test  = 'Test'
        Test1 = @{
            Test2 = 'Test2'
            Test3 = @{
                Test4 = 'Test4'
            }
        }
        Test2 = @(
            "1", "2", "3"
        )
        Test3 = [PSCustomObject] @{
            Test4 = 'Test4'
            Test5 = 'Test5'
        }
    }

    $New1 = Copy-Dictionary -Dictionary $Test
    $New1

    .NOTES

    #>
    [alias('Copy-Hashtable', 'Copy-OrderedHashtable')]
    [cmdletbinding()]
    param(
        [System.Collections.IDictionary] $Dictionary
    )
    $clone = [System.Management.Automation.PSSerializer]::Serialize($Dictionary, [int32]::MaxValue)
    return [System.Management.Automation.PSSerializer]::Deserialize($clone)
}