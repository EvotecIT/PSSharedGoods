
function Get-ComputerSMBShareList {
    <#
    .SYNOPSIS
    Enumerate shares on a remote or local host and returns the name, type, and special remark for those shares.

    .DESCRIPTION
    Enumerate shares on a remote or local host and returns the name, type, and special remark for those shares.
    Doesnt return the permissions on the share, or logging to given computer
    Similar to 'net view /All \\ComputerName'

    .PARAMETER ComputerName
    The host to enumerate the shares for. Can be accepted as pipeline input by value.

    .PARAMETER Name
    The name of the share to filter on. Can be accepted as pipeline input by value.

    .OUTPUTS
    [PSCustomObject]@{
        ComputerName = [String]'The computer the share relates to'
        Name = [String]'The name of the share'
        Path = [string]'\\ComputerName\Name\'
        Type = [Win32Share.ShareType] An flag enum of the share properties, can be
            Disk = Disk drive share
            PrintQueue = Print queue share
            CommunicationDevice = Communication device share
            Ipc = Interprocess communication share
            Temporary = A temporary share
            Special = Typically a special/admin share like IPC$, C$, ADMIN$
        Remark = [String]'More info on the share'
        TotalBytes = [System.Nullable[int]]
        TotalFreeBytes = [System.Nullable[int]]
        FreeBytesAvailableToUser = [System.Nullable[int]]
    }
    .LINK
    https://gist.github.com/jborean93/017d3d890ae8d33276a08d3f5cc7eb45

    .EXAMPLE
    Get-ComputerSMBShareList -ComputerName some-host

    .EXAMPLE
    Get-ComputerSMBShareList -ComputerName "DC1" | ft -AutoSize

    .NOTES
    Original author: Jordan Borean (@jborean93)

    Modified by: Matt Cargile (@mattcargile)
    Modified by: Przemyslaw Klys

    #>
    [CmdletBinding(DefaultParameterSetName = 'ComputerName')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ComputerName', Position = 0)]
        [string[]] $ComputerName,

        [Parameter(ValueFromPipeline, ParameterSetName = 'Pipeline')]

        [string] $InputObject,
        [Parameter(ParameterSetName = 'ComputerName', Position = 1)]
        [Parameter(ParameterSetName = 'Pipeline')]
        [SupportsWildcards()][Alias('ShareName')][string[]] $Name
    )

    begin {
        <#Check if loaded to make dot-source testing easier#>
        if (-not ('Win32Share.NativeMethods' -as [type])) {
            Add-Type -ErrorAction 'Stop' -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
namespace Win32Share
{
    public class NativeHelpers
    {
        [StructLayout(LayoutKind.Sequential)]
        public struct SHARE_INFO_1
        {
            [MarshalAs(UnmanagedType.LPWStr)] public string shi1_netname;
            public ShareType shi1_type;
            [MarshalAs(UnmanagedType.LPWStr)] public string shi1_remark;
        }
    }
    public class NativeMethods
    {
        [DllImport("Netapi32.dll")]
        public static extern UInt32 NetApiBufferFree(
            IntPtr Buffer);
        [DllImport("Netapi32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        public static extern Int32 NetShareEnum(
            string servername,
            UInt32 level,
            ref IntPtr bufptr,
            UInt32 prefmaxlen,
            ref UInt32 entriesread,
            ref UInt32 totalentries,
            ref UInt32 resume_handle);
        [DllImport("Kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        public static extern bool GetDiskFreeSpaceEx(
            string lpDirectoryName,
            ref UInt64 lpFreeBytesAvailableToCaller,
            ref UInt64 lptotalNumberOfBytes,
            ref UInt64 lpTotalNumberOfFreeBytes
        );
    }
    [Flags]
    public enum ShareType : uint
    {
        Disk = 0,
        PrintQueue = 1,
        CommunicationDevice = 2,
        Ipc = 3,
        Temporary = 0x40000000,
        Special = 0x80000000,
    }
}
'@
        }
        # $PSBoundParameters['PSC'] = $PSCmdlet

        foreach ($compNm in $ComputerName) {
            $PSBoundParameters['ComputerName'] = $compNm
            Get-ComputerSMBInfo @PSBoundParameters
        }
    }

    process {
        if ($InputObject) {
            $PSBoundParameters['ComputerName'] = $InputObject
            $null = $PSBoundParameters.Remove( 'InputObject')
            Get-ComputerSMBInfo @PSBoundParameters
        }
    }
}