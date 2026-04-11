---
title: "Convert identities and SIDs"
description: "Use PSSharedGoods identity helpers to normalize account names and SIDs."
layout: docs
---

This pattern is useful when reporting code receives mixed domain names, local identities, and raw SID values.

It comes from the source example at `Examples/ConvertIdentity1.ps1`.

## When to use this pattern

- You need a consistent identity shape for reporting.
- You receive a mix of account names and SIDs.
- You want helper output before permission remediation.

## Example

```powershell
Import-Module .\PSSharedGoods.psd1 -Force

@(
    Convert-Identity -Identity 'Everyone'
    Convert-Identity -Identity 'NT AUTHORITY\SYSTEM'
    ConvertTo-SID -Identity 'Domain Admins'
) | Format-Table
```

## What this demonstrates

- normalizing identity values
- using helper commands before reporting
- handling multiple identity input forms

## Source

- [ConvertIdentity1.ps1](https://github.com/EvotecIT/PSSharedGoods/blob/master/Examples/ConvertIdentity1.ps1)

