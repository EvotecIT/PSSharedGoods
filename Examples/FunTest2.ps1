

$Test = @{
    Name    = 'Przemek'
    Surname = 'Klys'
    Job     = 'IT'
    Other   = 'Some random comment'
    Other1  = 'Some random comment'
    Other2  = 'Some random comment'
    Other3  = 'Some random comment'
    Other4  = 'Some random comment'
    Other5  = 'Some random comment'
    Other6  = 'Some random comment'
}


$Test1 = [ordered] @{
    Name    = 'Przemek'
    Surname = 'Klys'
    Job     = 'IT'
    Other   = 'Some random comment'
    Other1  = 'Some random comment'
    Other2  = 'Some random comment'
    Other3  = 'Some random comment'
    Other4  = 'Some random comment'
    Other5  = 'Some random comment'
    Other6  = 'Some random comment'
}

function Get-ProcessMyTable {
    param(
        [System.Collections.IDictionary] $Table
    )
    $Table | Format-Table -AutoSize
}

#Get-ProcessMyTable -Table $Test
#Get-ProcessMyTable -Table $Test1



$MyValue = @('1', 1, 5)
[string[]] $SmallArray = 'one', '2', '3'
[int[]] $SmallInt = 1, 5, 7, 9

function Get-ProcessMyArray {
    param(
        [Array] $Array
    )

    foreach ($A in $Array) {
        if ($A -is [string]) {
            Write-Color 'String' -Color Green
        } elseIf ($A -is [int]) {
            Write-Color 'Int' -Color Red
        } else {
            Write-Color 'shouldnt happen' -Color Yellow
        }
    }
    $Array | Format-Table -AutoSize
}


function Get-ProcessMyIntArray {
    param(
        [int[]] $Array
    )

    foreach ($A in $Array) {
        if ($A -is [string]) {
            Write-Color 'String' -Color Green
        } elseIf ($A -is [int]) {
            Write-Color 'Int' -Color Red
        } else {
            Write-Color 'shouldnt happen' -Color Yellow
        }
    }
    $Array | Format-Table -AutoSize
}

function Get-ProcessMyStringArray {
    param(
        [string[]] $Array
    )

    foreach ($A in $Array) {
        if ($A -is [string]) {
            Write-Color 'String' -Color Green
        } elseIf ($A -is [int]) {
            Write-Color 'Int' -Color Red
        } else {
            Write-Color 'shouldnt happen' -Color Yellow
        }
    }
    $Array | Format-Table -AutoSize
}



Write-Color 'Example 1 - Array' -Color Blue -LinesBefore 1
Get-ProcessMyArray -Array $MyValue
Write-Color 'Example 2 - Array' -Color Blue -LinesAfter 1
Get-ProcessMyArray -Array $SmallArray
Write-Color 'Example 3 - Array' -Color Blue -LinesAfter 1
Get-ProcessMyArray -Array $SmallInt


Write-Color 'Example 1 - INT Array' -Color Blue -LinesBefore 1
Get-ProcessMyIntArray -Array $MyValue
Write-Color 'Example 2 - INT Array' -Color Blue -LinesAfter 1
Get-ProcessMyIntArray -Array $SmallArray
Write-Color 'Example 3 - INT Array' -Color Blue -LinesAfter 1
Get-ProcessMyIntArray -Array $SmallInt


Write-Color 'Example 1 - STRING Array' -Color Blue -LinesBefore 1
Get-ProcessMyStringArray -Array $MyValue
Write-Color 'Example 2 - STRING Array' -Color Blue -LinesAfter 1
Get-ProcessMyStringArray -Array $SmallArray
Write-Color 'Example 3 - STRING Array' -Color Blue -LinesAfter 1
Get-ProcessMyStringArray -Array $SmallInt
