function ConvertTo-PrettyObject {
    <#
    .SYNOPSIS
    Command to help with converting standard objects that could be nested objects into single level PSCustomObject

    .DESCRIPTION
    Command to help with converting standard objects that could be nested objects into single level PSCustomObject
    This is a help command for PSWriteHTML module and probably PSWriteOffice module to create tables from objects
    and make sure those tables are not nested and can be easily converted to HTML or Office tables without having to manually flatten them

    .PARAMETER Object
     Specifies the objects to convert to pretty format. Enter a variable that contains the objects, or type a command or expression that gets the objects. You can also pipe an object to ConvertTo-JsonLiteral

    .PARAMETER DateTimeFormat
    Changes DateTime string format. Default "yyyy-MM-dd HH:mm:ss"

    .PARAMETER NumberAsString
    Provides an alternative serialization option that converts all numbers to their string representation.

    .PARAMETER BoolAsString
    Provides an alternative serialization option that converts all bool to their string representation.

    .PARAMETER PropertyName
    Uses PropertyNames provided by user (only works with Force)

    .PARAMETER NewLineFormat
    Provides a way to configure how new lines are converted for property names

    .PARAMETER NewLineFormatProperty
    Provides a way to configure how new lines are converted for values

    .PARAMETER PropertyName
    Allows passing property names to be used for custom objects (hashtables and alike are unaffected)

    .PARAMETER ArrayJoin
    Forces any array to be a string regardless of depth level

    .PARAMETER ArrayJoinString
    Uses defined string or char for array join. By default it uses comma with a space when used.

    .PARAMETER Force
    Forces using property names from first object or given thru PropertyName parameter

    .EXAMPLE
    $Test1 = [PSCustomObject] @{
        Number     = 1
        Number2    = 2.2
        Bool       = $false
        Array      = @(
            'C:\Users\1Password.exe'
            "C:\Users\Ooops.exe"
            "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
            "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
        )
        EmptyArray = @()
        EmptyList  = [System.Collections.Generic.List[string]]::new()
        HashTable  = @{
            NumberAgain       = 2
            OrderedDictionary = [ordered] @{
                String    = 'test'
                HashTable = @{
                    StringAgain = "oops"
                }
            }
            Array             = @(
                'C:\Users\1Password.exe'
                "C:\Users\Ooops.exe"
                "\\EvoWin\c$\Users\przemyslaw klys\AppData\Local\1password\This is other\7\1Password.exe"
                "\\EvoWin\c$\Users\przemyslaw.klys\AppData\Local\1password\This is other\7\1Password.exe"
            )
        }
        DateTime   = Get-Date
    }

    $Test1 | ConvertTo-PrettyObject -ArrayJoinString "," -ArrayJoin | ConvertTo-Json | ConvertFrom-Json

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [alias('InputObject')][Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0, Mandatory)][Array] $Object,
        [int] $Depth,
        [switch] $AsArray,
        [string] $DateTimeFormat = "yyyy-MM-dd HH:mm:ss",
        [switch] $NumberAsString,
        [switch] $BoolAsString,
        [System.Collections.IDictionary] $NewLineFormat = @{
            NewLineCarriage = '\r\n'
            NewLine         = "\n"
            Carriage        = "\r"
        },
        [System.Collections.IDictionary] $NewLineFormatProperty = @{
            NewLineCarriage = '\r\n'
            NewLine         = "\n"
            Carriage        = "\r"
        },
        [System.Collections.IDictionary] $AdvancedReplace,
        [string] $ArrayJoinString,
        [switch] $ArrayJoin,
        [string[]]$PropertyName,
        [switch] $Force
    )
    Begin {
        filter IsNumeric() {
            return $_ -is [byte] -or $_ -is [int16] -or $_ -is [int32] -or $_ -is [int64]  `
                -or $_ -is [sbyte] -or $_ -is [uint16] -or $_ -is [uint32] -or $_ -is [uint64] `
                -or $_ -is [float] -or $_ -is [double] -or $_ -is [decimal]
        }
        filter IsOfType() {
            return $_ -is [bool] -or $_ -is [char] -or $_ -is [datetime] -or $_ -is [string] `
                -or $_ -is [timespan] -or $_ -is [URI] `
                -or $_ -is [byte] -or $_ -is [int16] -or $_ -is [int32] -or $_ -is [int64] `
                -or $_ -is [sbyte] -or $_ -is [uint16] -or $_ -is [uint32] -or $_ -is [uint64] `
                -or $_ -is [float] -or $_ -is [double] -or $_ -is [decimal]
        }
    }
    Process {
        for ($a = 0; $a -lt $Object.Count; $a++) {
            $NewObject = [ordered] @{}
            if ($Object[$a] -is [System.Collections.IDictionary]) {
                # Push to TEXT the same as [PSCustomObject]
                for ($i = 0; $i -lt ($Object[$a].Keys).Count; $i++) {
                    $Property = ([string[]]$Object[$a].Keys)[$i]
                    $DisplayProperty = $Property.Replace([System.Environment]::NewLine, $NewLineFormatProperty.NewLineCarriage).Replace("`n", $NewLineFormatProperty.NewLine).Replace("`r", $NewLineFormatProperty.Carriage)
                    $Value = $Object[$a].$Property
                    # the same code for PSCustomObject
                    if ($null -eq $Value) {
                        $NewObject[$DisplayProperty] = ""
                    } elseif ($Value -is [string]) {
                        foreach ($Key in $AdvancedReplace.Keys) {
                            $Value = $Value.Replace($Key, $AdvancedReplace[$Key])
                        }
                        $NewObject[$DisplayProperty] = $Value.Replace([System.Environment]::NewLine, $NewLineFormat.NewLineCarriage).Replace("`n", $NewLineFormat.NewLine).Replace("`r", $NewLineFormat.Carriage)
                    } elseif ($Value -is [DateTime]) {
                        $NewObject[$DisplayProperty] = $Object[$a].$Property.ToString($DateTimeFormat)
                    } elseif ($Value -is [bool]) {
                        if ($BoolAsString) {
                            $NewObject[$DisplayProperty] = "$Value"
                        } else {
                            $NewObject[$DisplayProperty] = $Value
                        }
                    } elseif ($Value -is [System.Collections.IDictionary]) {
                        # We force it to max depth 0
                        $NewObject[$DisplayProperty] = "$Value"
                    } elseif ($Value -is [System.Collections.IList] -or $Value -is [System.Collections.ReadOnlyCollectionBase]) {
                        if ($ArrayJoin) {
                            $Value = $Value -join $ArrayJoinString
                            $Value = "$Value".Replace([System.Environment]::NewLine, $NewLineFormat.NewLineCarriage).Replace("`n", $NewLineFormat.NewLine).Replace("`r", $NewLineFormat.Carriage)
                            $NewObject[$DisplayProperty] = "$Value"
                        } else {
                            # We force it to max depth 0
                            $Value = "$Value".Replace([System.Environment]::NewLine, $NewLineFormat.NewLineCarriage).Replace("`n", $NewLineFormat.NewLine).Replace("`r", $NewLineFormat.Carriage)
                            $NewObject[$DisplayProperty] = "$Value"
                        }
                    } elseif ($Value -is [System.Enum]) {
                        $NewObject[$DisplayProperty] = ($Value).ToString()
                    } elseif (($Value | IsNumeric) -eq $true) {
                        $Value = $($Value).ToString().Replace(',', '.')
                        if ($NumberAsString) {
                            $NewObject[$DisplayProperty] = "$Value"
                        } else {
                            $NewObject[$DisplayProperty] = $Value
                        }
                    } elseif ($Value -is [PSObject]) {
                        # We force it to max depth 0
                        $NewObject[$DisplayProperty] = "$Value"
                    } else {
                        $Value = $Value.ToString().Replace([System.Environment]::NewLine, $NewLineFormat.NewLineCarriage).Replace("`n", $NewLineFormat.NewLine).Replace("`r", $NewLineFormat.Carriage)
                        $NewObject[$DisplayProperty] = "$Value"
                    }
                }
                [PSCustomObject] $NewObject
            } elseif ($Object[$a] | IsOfType) {
                # $Value = ConvertTo-StringByType -Value $Object[$a] -DateTimeFormat $DateTimeFormat -NumberAsString:$NumberAsString -BoolAsString:$BoolAsString -Depth $InitialDepth -MaxDepth $MaxDepth -TextBuilder $TextBuilder -NewLineFormat $NewLineFormat -NewLineFormatProperty $NewLineFormatProperty -Force:$Force -ArrayJoin:$ArrayJoin -ArrayJoinString $ArrayJoinString -AdvancedReplace $AdvancedReplace
                # $null = $TextBuilder.Append($Value)
                $Object[$a]
            } else {
                if ($Force -and -not $PropertyName) {
                    $PropertyName = $Object[0].PSObject.Properties.Name
                } elseif ($Force -and $PropertyName) {

                } else {
                    $PropertyName = $Object[$a].PSObject.Properties.Name
                }
                foreach ($Property in $PropertyName) {
                    $DisplayProperty = $Property.Replace([System.Environment]::NewLine, $NewLineFormatProperty.NewLineCarriage).Replace("`n", $NewLineFormatProperty.NewLine).Replace("`r", $NewLineFormatProperty.Carriage)
                    $Value = $Object[$a].$Property
                    if ($null -eq $Value) {
                        $NewObject[$DisplayProperty] = ""
                    } elseif ($Value -is [string]) {
                        foreach ($Key in $AdvancedReplace.Keys) {
                            $Value = $Value.Replace($Key, $AdvancedReplace[$Key])
                        }
                        $NewObject[$DisplayProperty] = $Value.Replace([System.Environment]::NewLine, $NewLineFormat.NewLineCarriage).Replace("`n", $NewLineFormat.NewLine).Replace("`r", $NewLineFormat.Carriage)
                    } elseif ($Value -is [DateTime]) {
                        $NewObject[$DisplayProperty] = $Object[$a].$Property.ToString($DateTimeFormat)
                    } elseif ($Value -is [bool]) {
                        if ($BoolAsString) {
                            $NewObject[$DisplayProperty] = "$Value"
                        } else {
                            $NewObject[$DisplayProperty] = $Value
                        }
                    } elseif ($Value -is [System.Collections.IDictionary]) {
                        # We force it to max depth 0
                        $NewObject[$DisplayProperty] = "$Value"
                    } elseif ($Value -is [System.Collections.IList] -or $Value -is [System.Collections.ReadOnlyCollectionBase]) {
                        if ($ArrayJoin) {
                            $Value = $Value -join $ArrayJoinString
                            $Value = "$Value".Replace([System.Environment]::NewLine, $NewLineFormat.NewLineCarriage).Replace("`n", $NewLineFormat.NewLine).Replace("`r", $NewLineFormat.Carriage)
                            $NewObject[$DisplayProperty] = "$Value"
                        } else {
                            # We force it to max depth 0
                            $Value = "$Value".Replace([System.Environment]::NewLine, $NewLineFormat.NewLineCarriage).Replace("`n", $NewLineFormat.NewLine).Replace("`r", $NewLineFormat.Carriage)
                            $NewObject[$DisplayProperty] = "$Value"
                        }
                    } elseif ($Value -is [System.Enum]) {
                        $NewObject[$DisplayProperty] = ($Value).ToString()
                    } elseif (($Value | IsNumeric) -eq $true) {
                        #$Value = $($Value).ToString().Replace(',', '.')
                        if ($NumberAsString) {
                            $NewObject[$DisplayProperty] = "$Value"
                        } else {
                            $NewObject[$DisplayProperty] = $Value
                        }
                    } elseif ($Value -is [PSObject]) {
                        # We force it to max depth 0
                        $NewObject[$DisplayProperty] = "$Value"
                    } else {
                        $Value = $Value.ToString().Replace([System.Environment]::NewLine, $NewLineFormat.NewLineCarriage).Replace("`n", $NewLineFormat.NewLine).Replace("`r", $NewLineFormat.Carriage)
                        $NewObject[$DisplayProperty] = "$Value"
                    }
                }
                [PSCustomObject] $NewObject
            }
        }
    }
}

<#
$DataTable3 = @(
    [PSCustomObject] @{
        'Test6'        = @"
        Test1
        Test2
        Test3

        Test4
"@
        'Test7'        = 'Test' + "`n`n" + "Oops \n\n"
        'Test8"Oopps"' = 'MyTest "Ofcourse"'
        "Test9'Ooops'" = "MyTest 'Ofcourse'"
    }
)

$Output1 = $DataTable3 | ConvertTo-PrettyObject | ConvertTo-Json | ConvertFrom-Json
$Output2 = $DataTable3 | ConvertTo-Json | ConvertFrom-Json
#$Output1.'Test8"Oopps"'
#$Output1."Test9'Ooops'"
#$Output2.'Test8"Oopps"'
#$Output2."Test9'Ooops'"

$Output1 | Format-Table *
$Output2 | Format-Table *
#>

# $DataTable3 = [PSCustomObject] @{
#     'Test1'        = 'Test' + [System.Environment]::NewLine + 'test3';
#     'Test2'        = 'Test' + [System.Environment]::NewLine + 'test3' + "`n test"
#     'Test3'        = 'Test' + [System.Environment]::NewLine + 'test3' + "`r`n test"
#     'Test4'        = 'Test' + [System.Environment]::NewLine + 'test3' + "`r test"
#     'Test5'        = 'Test' + "`r`n" + 'test3' + "test"
#     'Test6'        = @"
#     Test1
#     Test2
#     Test3

#     Test4
# "@
#     'Test7'        = 'Test' + "`n`n" + "Oops"
#     'Test9'        = 'Test' + "<Br>" + "Oops"
#     'Test8"Oopps"' = 'MyTest "Ofcourse"'
#     "Test9'Ooops'" = "MyTest 'Ofcourse'"

# }

# $Output1 = $DataTable3 | ConvertTo-PrettyObject -NewLineFormatProperty @{
#     NewLineCarriage = '<br>'
#     NewLine         = "\n"
#     Carriage        = "\r"
# }
# $Output1 | ConvertTo-Json
