
<# ReferenceOnly
It's not really a function. If you use this it will display Get-CommandInfo. It's something you can use for reference if needed.
#>
Function Get-CommandInfo {
    $Command = @{}
    $Command.Type = "$($MyInvocation.MyCommand.CommandType)".ToLower()
    $Command.Name = "$($MyInvocation.MyCommand.Name)"
    return $Command
}