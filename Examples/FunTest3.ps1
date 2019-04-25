$Object1 = @{
    Name   = 'Test1'
    Status = 1
}
$Object2 = @{
    Name   = 'Tests2'
    Status = $null
}

$Array = @($Object1, $Object2)

$Test1 = While ($Array.Status -ne $null) {
    $true
    foreach ($A in $Array) {
        $A.Status = $null
    }
}

$Test1

$Test2 = While ($null -ne $Array.Status) {
    $true
    foreach ($A in $Array) {
        $A.Status = $null
    }
}

# This will never end....

$Test2