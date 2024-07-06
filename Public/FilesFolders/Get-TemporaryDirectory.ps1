function Get-TemporaryDirectory {
    <#
    .SYNOPSIS
    Creates a temporary directory and returns its path.

    .DESCRIPTION
    This function generates a temporary directory with a unique name and returns the full path to the directory.

    .EXAMPLE
    $tempDir = Get-TemporaryDirectory
    $tempDir
    Output:
    C:\Users\Username\AppData\Local\Temp\abcde12345

    .NOTES
    The temporary directory is created using a random string name with specified characteristics.
    #>
    param(

    )
    $TemporaryFolder = Get-RandomStringName -Size 13 -LettersOnly -ToLower
    $TemporaryPath = [system.io.path]::GetTempPath()
    $Output = New-Item -ItemType Directory -Path $TemporaryPath -Name $TemporaryFolder -Force
    if (Test-Path -LiteralPath $Output.FullName) {
        $Output
    }
}