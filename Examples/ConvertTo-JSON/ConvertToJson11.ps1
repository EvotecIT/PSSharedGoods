

[Array] $ConditionsContainer = @(
    [ordered]@{
        logic      = 'AND'
        conditions = @(
            [ordered] @{
                columnName      = 'name'
                columnId        = 5
                operator        = 'eq'
                type            = 'test'
                value           = 1.23
                dataStore       = 'html'
                caseInsensitive = $false
            }

        )
    }
)

$ConditionsContainer | ConvertTo-JsonLiteral -Depth 5 -AsArray