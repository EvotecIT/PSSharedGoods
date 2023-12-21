function Get-ComputerSMBInfo {
    [cmdletbinding()]
    param(
        [string] $ComputerName,
        [string[]] $Name,
        [switch] $SkipDiskSpace #,
        # [System.Management.Automation.PSCmdlet]$PSC
    )
    $buffer = [IntPtr]::Zero
    $read = 0
    $total = 0
    $resume = 0

    $res = [Win32Share.NativeMethods]::NetShareEnum(
        $ComputerName,
        1, # SHARE_INFO_1
        [ref]$buffer,
        ([UInt32]"0xFFFFFFFF"), # MAX_PREFERRED_LENGTH
        [ref]$read,
        [ref]$total,
        [ref]$resume
    )

    if ($res -ne 0) {
        $exp = [System.ComponentModel.Win32Exception]$res
        $er = [System.Management.Automation.ErrorRecord]::new(
            $exp,
            'Win32Share.NativeMethods.GetSmbInf.RemoteException',
            [System.Management.Automation.ErrorCategory]::NotSpecified,
            $ComputerName
        )
        $er.ErrorDetails = "Failed to enum share for '$ComputerName': $($exp.Message)"
        if ($ErrorActionPreference -eq 'Stop') {
            Write-Error -ErrorRecord $er
        } else {
            Write-Warning -Message "Get-ComputerSMBShareList - Failed to enumarate share on '$ComputerName'."
        }
        return
    }
    try {
        $entryPtr = $buffer
        for ($i = 0; $i -lt $total; $i++) {
            $shareInfo = [System.Runtime.InteropServices.Marshal]::PtrToStructure($entryPtr, [Type]([Win32Share.NativeHelpers+SHARE_INFO_1]))

            $netNm = $shareInfo.shi1_netname
            if ($Name) {
                $isLike = $false
                foreach ($nm in $Name) {
                    if ($netNm -like $nm) {
                        $isLike = $true
                        continue
                    }
                }
                if (-not $isLike) {
                    $entryPtr = [IntPtr]::Add($entryPtr, [System.Runtime.InteropServices.Marshal]::SizeOf($shareInfo))
                    continue
                }
            }
            $shTyp = $shareInfo.shi1_type
            # API below requires an ending backslash
            $shrPath = "\\$ComputerName\$netNm\"
            if (-not $SkipDiskSpace) {
                $freeBytesAvailableToCaller = 0
                [System.Nullable[UInt64]]$freeBytesAvailableToCallerNull = $null
                $totalNumberOfBytes = 0
                [System.Nullable[UInt64]]$totalNumberOfBytesNull = $null
                $totalNumberOfFreeBytes = 0
                [System.Nullable[UInt64]]$totalNumberOfFreeBytesNull = $null
                $lastWin32Error = 0

                if (($shTyp -bor [Win32Share.ShareType]::Disk) -eq [Win32Share.ShareType]::Disk) {
                    $dskRes = [Win32Share.NativeMethods]::GetDiskFreeSpaceEx(
                        $shrPath,
                        [ref]$freeBytesAvailableToCaller,
                        [ref]$totalNumberOfBytes,
                        [ref]$totalNumberOfFreeBytes
                    )
                    if ($dskRes) {
                        $freeBytesAvailableToCallerNull = $freeBytesAvailableToCaller
                        $totalNumberOfBytesNull = $totalNumberOfBytes
                        $totalNumberOfFreeBytesNull = $totalNumberOfFreeBytes
                    } else {
                        # https://stackoverflow.com/questions/17918266/winapi-getlasterror-vs-marshal-getlastwin32error
                        $lastWin32Error = [System.Runtime.InteropServices.Marshal]::GetLastWin32Error()
                        $exp = [System.ComponentModel.Win32Exception]$lastWin32Error
                        $er = [System.Management.Automation.ErrorRecord]::new(
                            $exp,
                            'Win32Share.NativeMethods.GetSmbInf.ShareException',
                            [System.Management.Automation.ErrorCategory]::NotSpecified,
                            $shrPath
                        )
                        $er.ErrorDetails = "Failed to get disk space on '$shrPath' for '$ComputerName': $($exp.Message)"
                        #$PSC.WriteError( $er )
                        if ($ErrorActionPreference -eq 'Stop') {
                            Write-Error -ErrorRecord $er
                        } else {
                            Write-Warning -Message "Get-ComputerSMBShareList - Failed to get disk space on '$shrPath' for '$ComputerName': $($exp.Message)"
                        }
                    }
                }
                [PSCustomObject]@{
                    PSTypeName               = 'Win32Share.NativeMethods' # Used in Formatter
                    ComputerName             = $ComputerName
                    Path                     = $shrPath
                    Name                     = $netNm
                    Type                     = $shTyp
                    Remark                   = $shareInfo.shi1_remark
                    TotalBytes               = $totalNumberOfBytesNull
                    TotalFreeBytes           = $totalNumberOfFreeBytesNull
                    FreeBytesAvailableToUser = $freeBytesAvailableToCallerNull
                }
            } else {
                [PSCustomObject]@{
                    PSTypeName   = 'Win32Share.NativeMethods' # Used in Formatter
                    ComputerName = $ComputerName
                    Path         = $shrPath
                    Name         = $netNm
                    Type         = $shTyp
                    Remark       = $shareInfo.shi1_remark
                }
            }

            $entryPtr = [IntPtr]::Add($entryPtr, [System.Runtime.InteropServices.Marshal]::SizeOf($shareInfo))
        }
    } finally {
        $null = [Win32Share.NativeMethods]::NetApiBufferFree($buffer)
    }
}