---
external help file: DellOpenManage-help.xml
Module Name: DellOpenManage
online version:
schema: 2.0.0
---

# Get-OMEIdentityPool

## SYNOPSIS
Get list of Identity Pools from OME

## SYNTAX

```
Get-OMEIdentityPool [[-Value] <Object>] [[-FilterBy] <String>] [<CommonParameters>]
```

## DESCRIPTION
This script uses the OME REST API.
Note that the credentials entered are not stored to disk.

## EXAMPLES

### EXAMPLE 1
```
Get-OMEIdentityPool | Format-Table
```

## PARAMETERS

### -Value
String containing search value.
Use with -FilterBy parameter.
Supports regex based matching.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -FilterBy
Filter the results by (Default="Name", "Id")

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Name
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
