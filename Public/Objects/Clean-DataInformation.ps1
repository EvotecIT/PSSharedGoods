function Clear-DataInformation {
    <#
    .SYNOPSIS
    Cleans up data information by removing empty values and specified keys.

    .DESCRIPTION
    The Clear-DataInformation function removes empty values and specified keys from the provided data. It iterates through the data structure and removes keys with null values or keys not in the specified types required array. It also removes empty domains and the 'FoundDomains' key if it becomes empty.

    .PARAMETER Data
    The data structure containing information to be cleaned.

    .PARAMETER TypesRequired
    An array of types that are required to be kept in the data structure.

    .PARAMETER DontRemoveSupportData
    A switch parameter to indicate whether to skip removing keys not in TypesRequired.

    .PARAMETER DontRemoveEmpty
    A switch parameter to indicate whether to skip removing keys with null values.

    .EXAMPLE
    $data = @{
        FoundDomains = @{
            Domain1 = @{
                Key1 = 'Value1'
                Key2 = $null
            }
            Domain2 = @{
                Key1 = 'Value1'
                Key2 = 'Value2'
            }
        }
    }
    Clear-DataInformation -Data $data -TypesRequired @('Key1') -DontRemoveSupportData

    This example removes keys with null values from the 'FoundDomains' data structure, keeping only keys of type 'Key1'.

    #>
    [CmdletBinding()]
    param(
        [System.Collections.IDictionary] $Data,
        [Array] $TypesRequired,
        [switch] $DontRemoveSupportData,
        [switch] $DontRemoveEmpty
    )
    # Check each domain for empty values and remove if empty
    foreach ($Domain in $Data.FoundDomains.Keys) {
        $RemoveDomainKeys = foreach ($Key in $Data.FoundDomains.$Domain.Keys) {
            if ($null -eq $Data.FoundDomains.$Domain.$Key) {
                if (-not $DontRemoveEmpty) {
                    $Key
                }
                continue
            }
            if ($Key -notin $TypesRequired -and $DontRemoveSupportData -eq $false) {
                $Key
            }
        }
        foreach ($Key in $RemoveDomainKeys) {
            $Data.FoundDomains.$Domain.Remove($Key)
        }
    }

    # Remove domains if empty
    $RemoveDomains = foreach ($Domain in $Data.FoundDomains.Keys) {
        if ($Data.FoundDomains.$Domain.Count -eq 0) {
            $Domain
        }
    }
    foreach ($Domain in $RemoveDomains) {
        $Data.FoundDomains.Remove($Domain)
    }
    # Remove FoundDomains if empty
    if ($Data.FoundDomains.Count -eq 0) {
        $Data.Remove('FoundDomains')
    }

    # Remove empty keys in Forest
    $RemoveKeys = foreach ($Key in $Data.Keys) {
        if ($Key -eq 'FoundDomains') {
            # Skip this key
            continue
        }
        if ($null -eq $Data.$Key) {
            if (-not $DontRemoveEmpty) {
                $Key
            }
            continue
        }
        if ($Key -notin $TypesRequired -and $DontRemoveSupportData -eq $false) {
            $Key
        }
    }
    foreach ($Key in $RemoveKeys) {
        $Data.Remove($Key)
    }
}