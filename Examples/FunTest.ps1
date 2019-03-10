Function Show-FirstExample {
    param(
        [string[]] $Test
    )  
    foreach ($my in $Test) {
        $my
    }
}

Write-Color 'Example 1' -Color Cyan

$Value1 = Show-FirstExample -Test 'one', 'two'
$Value1 -is [array]

$Value2 = Show-FirstExample -Test 'one'
$Value2 -is [array]

function Show-SecondExample {
    param(
        [string[]] $Test
    )  
    [Array] $Output = foreach ($my in $Test) {
        $my
    }
    # I want to do something with value before returning
    if ($Output -is [array]) {
        Write-Color 'Array' -Color Green
    }
    # Actually returning
    $Output

}

Write-Color 'Example 2' -Color Cyan

$Value1 = Show-SecondExample -Test 'one', 'two'
$Value1 -is [array]
$Value2 = Show-SecondExample -Test 'one'
$Value2 -is [array]

function Show-ThirdExample {
    param(
        [string[]] $Test
    )  
    $Output = foreach ($my in $Test) {
        $my
    }
    # I want to do something with value before returning
    if ($Output -is [array]) {
        Write-Color 'Array' -Color Green
    }
    # Actually returning
    , $Output
}

Write-Color 'Example 3' -Color Cyan

$Value1 = Show-ThirdExample -Test 'one', 'two'
$Value1 -is [array]

$Value2 = Show-ThirdExample -Test 'one'
$Value2 -is [array]

function Show-FourthExample {
    param(
        [string[]] $Test
    )  
    [Array] $Output1 = foreach ($my in $Test) {
        $my
    }
    [Array] $Output2 = foreach ($my in $Test) {
        $my
    }
    # I want to do something with value before returning
    if (($Output1 + $Output2) -is [array]) {
        Write-Color 'Array' -Color Green
    }
    # Actually returning
    , ($Output1 + $Output2) 
}

Write-Color 'Example 4' -Color Cyan

$Value1 = Show-FourthExample -Test 'one', 'two'
$Value1 -is [array]

$Value2 = Show-FourthExample -Test 'one'
$Value2 -is [array]


function Show-FifthExample {
    param(
        [string[]] $Test
    )  
    if ($Test -contains 'one') {
        'one'
    }
    if ($Test -contains 'two') {
        'two'
    }
}

Write-Color 'Example 5' -Color Cyan

$Value1 = Show-FifthExample -Test 'one', 'two'
$Value1 -is [array]

$Value2 = Show-FifthExample -Test 'one'
$Value2 -is [array]


function Show-FifthExampleComplicated {
    param(
        [string[]] $Test
    )  
    $Value = @()
    if ($Test -contains 'one') {
        $Value += 'one'
    }
    if ($Test -contains 'two') {
        $Value += 'two'
    }

    # Do something with $Value
    if ($Value.Count -eq 2) {
        Write-Color 'Happy ', 'Birthday' -Color Red, Yellow
    }
    , $Value
}


Write-Color 'Example 5 Complicated' -Color Cyan

$Value1 = Show-FifthExampleComplicated -Test 'one', 'two'
$Value1 -is [array]

$Value2 = Show-FifthExampleComplicated -Test 'one'
$Value2 -is [array]


#>

<#
function Show-SixthExample {
    param(
        [string[]] $Test
    )
    $Output = @(
        if ($Test -contains 'one') {
            'one'
        }
        if ($Test -contains 'two') {
            'two'
        }
    )
    , $Output
}

Write-Color 'Example 6' -Color Cyan

$Value1 = Show-SixthExample -Test 'one', 'two'
$Value1 -is [array]

$Value2 = Show-SixthExample -Test 'one'
$Value2 -is [array]

#>

function Show-SeventhExample {
    param(
        [string[]] $Test
    )
    $Output = @(
        if ($Test -contains 'one') {
            'one'
        }
        if ($Test -contains 'two') {
            'two'
        }
        foreach ($T in $Test) {
            "modified$T"
        }
        $i = 1
        do {
            $i++
            'one'
        } while ($i -le 5)
    )

    # Now we can process whole output with just one assingment
    if ($Output.Count -eq 4) {
        Write-Color 'Hurray' -Color Red
    }

    , $Output
}

Write-Color 'Example 7' -Color Cyan

$Value1 = Show-SeventhExample -Test 'one', 'two'
$Value1 -is [array]
$Value1.Count
Write-Color 'Example 7', ' - ', 'Value 1 output in one line' -Color DarkMagenta, White, Green
$Value1 -join ','

$Value2 = Show-SeventhExample -Test 'one'
$Value2 -is [array]
$Value2.Count
Write-Color 'Example 7', ' - ', 'Value 2 output in one line' -Color DarkMagenta, White, Yellow
$Value2 -join ','