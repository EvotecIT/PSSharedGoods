Clear-Host

Import-Module .\PSSharedGoods.psd1 -Force

# $T = [PSCustomObject] @{
#     Test   = 1
#     Test2  = 7
#     Ole    = 'bole'
#     Trolle = 'A'
#     Alle   = 'sd'
# }

# $T1 = [PSCustomObject] @{
#     Test   = 1
#     Test2  = 7
#     Ole    = 'bole'
#     Trolle = 'A'
#     Alle   = 'sd'
# }

# $T2 = [ordered] @{
#     Test   = 1
#     Test2  = 7
#     Ole    = 'bole'
#     Trolle = 'A'
#     Alle   = 'sd'
# }
# $T3 = @{
#     Test   = 1
#     Test2  = 7
#     Ole    = 'bole'
#     Trolle = 'A'
#     Alle   = 'sd'
# }

# Format-TransposeTable -Object @($T) -Sort ASC -Legacy | Format-Table
# Format-TransposeTable -Object @($T) -Sort DESC -Legacy | Format-Table
# Format-TransposeTable -Object @($T) -Legacy | Format-Table

# Format-TransposeTable -Object @($T2) -Sort ASC -Legacy | Format-Table
# Format-TransposeTable -Object @($T2) -Sort DESC -Legacy | Format-Table
# Format-TransposeTable -Object @($T2) -Legacy | Format-Table

$T = [PSCustomObject] @{
    Onet   = 'Test'
    Name   = "Server 1"
    Test   = 1
    Test2  = 7
    Ole    = 'bole'
    Trolle = 'A'
    Alle   = 'sd'
}
$T1 = [PSCustomObject] @{
    Name   = "Server 2"
    Test   = 2
    Test2  = 3
    Ole    = '1bole'
    Trolle = 'A'
    Alle   = 'sd'
}

Format-TransposeTable -Object @($T, $T1) -Property "Name" | Format-Table

$T2 = [ordered] @{
    Onet   = 'Test'
    Name   = "Server 1"
    Test   = 1
    Test2  = 7
    Ole    = 'bole'
    Trolle = 'A'
    Alle   = 'sd'
}
$T3 = [ordered] @{
    Name   = "Server 2"
    Test   = 2
    Test2  = 3
    Ole    = '1bole'
    Trolle = 'A'
    Alle   = 'sd'
}

$Test = Format-TransposeTable -Object @($T2, $T3)
$Test | Format-Table


# Format-TransposeTable -Object @($T) | Format-Table