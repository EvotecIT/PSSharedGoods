# Some input data - simplified for example purposes
$SomeData = @('be', 'me', 'one', 'more', 'time')

$GenericList1 = [System.Collections.Generic.List[Object]]::new()
$GenericList2 = [System.Collections.Generic.List[Object]]::new()

foreach ($Something in $SomeData) {
    $GenericList1.Add("MyValue $Something")
    $GenericList2.Add("Other $Something")
}

$GenericList1.Count
$GenericList2.Count

$GenericList1.Remove('MyValue be')
$GenericList1.Count
$GenericList1 -join ','
