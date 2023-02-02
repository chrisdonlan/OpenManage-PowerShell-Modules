---
external help file: DellOpenManage-help.xml
Module Name: DellOpenManage
online version:
schema: 2.0.0
---

# Invoke-OMEFirmwareBaselineRefresh

## SYNOPSIS
Check or refresh compliance for a firmware baseline

## SYNTAX

```
Invoke-OMEFirmwareBaselineRefresh [-Baseline] <FirmwareBaseline> [-Wait] [[-WaitTime] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
A baseline is used to compare firmware versions against a catalog

## EXAMPLES

### EXAMPLE 1
```
"TestBaseline01"  | Get-OMEFirmwareBaseline | Invoke-OMEFirmwareBaselineRefresh -Wait
```

Refresh compliance for firmware baseline

## PARAMETERS

### -Baseline
Object of type FirmwareBaseline returned from Get-OMEFirmwareBaseline function

```yaml
Type: FirmwareBaseline
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Wait
Wait for job to complete

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

### -WaitTime
Time, in seconds, to wait for the job to complete

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 3600
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### FirmwareBaseline
## OUTPUTS

## NOTES

## RELATED LINKS
