function Clear-DataInformation {
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