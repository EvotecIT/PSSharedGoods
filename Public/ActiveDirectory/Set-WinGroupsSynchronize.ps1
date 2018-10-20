function Set-WinGroupsSynchronize($GroupFrom, $GroupTo, $LogFile = "") {
    $g1 = Get-ADGroupMember -Identity $GroupFrom | Select-Object Name, ObjectClass, SamAccountName, UserPrincipalName | ToArray
    $g2 = @(Get-ADGroupMember -Identity $GroupTo | Select-Object Name, ObjectClass, SamAccountName, UserPrincipalName)#  | ToArray


    #$g1.Count
    #$g2.Count

    foreach ($u in $g1) {
        #Write-Color "$($u.UserPrincipalName)" -Color White
        if ($u.ObjectClass -eq "user") {

            if (!($g2.count -lt 1)) {
                if ($g2.SamAccountName -notcontains $u.SamAccountName) {
                    Write-Color "Not a member ", $u.SamAccountName, " of $GroupTo", ". Adding!" -Color Red -LogFile $LogFile
                    Add-ADGroupMember -Identity $GroupTo -Members $u.SamAccountName
                } else {
                    #Write-Color "Already a member ", $u.SamAccountName, " of $GroupTo", ". Skipping!" -Color Green
                }
            } else {
                Write-Color "Not a member ", $u.SamAccountName, " of $GroupTo", ". Adding!" -Color Red -LogFile $LogFile
                Add-ADGroupMember -Identity $GroupTo -Members $u.SamAccountName
            }

        } else {
            Write-Color "Not a user ", $u.Name -Color White
        }
    }
    foreach ($u in $g2) {
        if ($u.ObjectClass -eq "user") {
            if (!($g1.count -lt 1)) {
                if ($g1.SamAccountName -notcontains $u.SamAccountName) {
                    Write-Color "Not a member of $GroupFrom - requires removal from $GroupTo ", $u.SamAccountName -Color Red -LogFile $LogFile
                    Remove-ADGroupMember -Identity $GroupTo -Members $u.SamAccountName -Confirm:$false
                } else {
                    #Write-Color "Already a member of $GroupTo and $GroupFrom - skipping ", $u.SamAccountName -Color Green
                }
            } else {
                Remove-ADGroupMember -Identity $GroupTo -Members $u.SamAccountName -Confirm:$false
            }
        } else {
            Write-Color "Not a user ", $u.Name -Color White
        }
    }

}