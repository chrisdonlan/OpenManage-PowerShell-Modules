---
external help file: DellOpenManage-help.xml
Module Name: DellOpenManage
online version:
schema: 2.0.0
---

# Get-OMEDiscovery

## SYNOPSIS
Get firmware/driver catalog from OpenManage Enterprise

## SYNTAX

```
Get-OMEDiscovery [[-Value] <String[]>] [[-FilterBy] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns all catalogs if no input received

## EXAMPLES

### EXAMPLE 1
```
Get-OMEDiscovery | Format-Table
```

Get all discovery jobs

### EXAMPLE 2
```
"DRM" | Get-OMEDiscovery | Format-Table
```

Get job by name by name

## PARAMETERS

### -Value
String containing search value.
Use with -FilterBy parameter

```yaml
Type: String[]
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

### String[]
## OUTPUTS

## NOTES

## RELATED LINKS
