---
external help file: PSSharedGoods-help.xml
Module Name: PSSharedGoods
online version:
schema: 2.0.0
---

# Merge-Array

## SYNOPSIS
Merge-Array allows to merge two or more arrays together.

## SYNTAX

```
Merge-Array [[-Array] <Array[]>] [-Prescan]
```

## DESCRIPTION
Merge-Array allows to merge two or more arrays together.
It copies headers from each Array and merges them together allowing for fulll output. 
When used with Prescan parameter it actually is able to show headers from all arrays

## EXAMPLES

### EXAMPLE 1
```
$Array1 = @(
```

\[PSCustomObject\] @{ Name = 'Company1'; Count = 259  }
    \[PSCustomObject\] @{ Name = 'Company2'; Count = 300 }
)
$Array2 = @(
    \[PSCustomObject\] @{ Name = 'Company1'; Count = 25 }
    \[PSCustomObject\] @{ Name = 'Company2'; Count = 100 }
)
$Array3 = @(
    \[PSCustomObject\] @{ Name1 = 'Company1'; Count3 = 25 }
    \[PSCustomObject\] @{ Name1 = 'Company2'; Count3 = 100 }
    \[PSCustomObject\] @{ Name2 = 'Company2'; Count3 = 100 }
)

$Array1 | Format-Table -AutoSize
$Array2 | Format-Table -AutoSize
$Array3 | Format-Table -AutoSize

Merge-Array -Array $Array1, $Array2, $Array3 | Format-Table -AutoSize
Merge-Array -Array $Array1, $Array2, $Array3 -Prescan | Format-Table -AutoSize

## PARAMETERS

### -Array
List of Arrays to process

```yaml
Type: Array[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Prescan
Scans each element of each array for headers.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
General notes

## RELATED LINKS
