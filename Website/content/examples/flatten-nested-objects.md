---
title: "Flatten nested objects"
description: "Use PSSharedGoods to flatten nested objects before reports or comparisons."
layout: docs
---

This pattern is useful when an API or configuration object is too nested for a readable table.

It comes from the source example at `Examples/ConvertFlatObject.ps1`.

## When to use this pattern

- You need a table-friendly object shape.
- You want to compare nested configuration snapshots.
- You are preparing data for CSV, HTML, or console output.

## Example

```powershell
Import-Module .\PSSharedGoods.psd1 -Force

$object = [ordered]@{
    Name = 'Example'
    Address = [ordered]@{
        City = 'Warsaw'
        Country = [ordered]@{ Name = 'Poland' }
    }
}

$object | ConvertTo-FlatObject | Format-Table
```

## What this demonstrates

- flattening nested hashtables
- preparing data for exports
- keeping report input predictable

## Source

- [ConvertFlatObject.ps1](https://github.com/EvotecIT/PSSharedGoods/blob/master/Examples/ConvertFlatObject.ps1)

