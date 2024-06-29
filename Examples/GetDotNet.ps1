
$PSVersionTable
$PSVersionTable.DotNetVersion = [System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription
$PSVersionTable.OSArchitecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture

[version]([System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription -split '\s' | Select-Object -Last 1)

[version][regex]::Match([System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription, '(\d\.?){3,}$').Value