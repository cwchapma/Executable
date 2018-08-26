---
external help file: Executable-help.xml
Module Name: Executable
online version:
schema: 2.0.0
---

# Invoke-Executable

## SYNOPSIS
Executes a executable file (*.exe) and handles stderr and exit codes

## SYNTAX

```
Invoke-Executable [-Command] <String[]> [-AllowableExitCodes <Int32[]>] [-StdErrAsErrorRecords]
 [<CommonParameters>]
```

## DESCRIPTION
By default when powershell runs an executable any output to stderr is converted to an ErrorRecord.
Many console applications simply write to stderr as a way of separating output from stdout - not because there was an error.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Invoke-Executable "robocopy C:\src C:\dest" -AllowableExitCodes 0,1,2,3,7
```

Runs the executable robocopy.exe (presumably to copy C:\src to C:\dest) 
and will not throw an exception if the exit code is one of 0,1,2,3, or 7

## PARAMETERS

### -Command

The executable and arguments

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -AllowableExitCodes

A list of exit codes that will not cause an exception to be thrown.  By default, only an exit code of 0 is allowed.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @(0)
Accept pipeline input: False
Accept wildcard characters: False
```

### -StdErrAsErrorRecords

Causes lines written to stderr to be added to the output as ErrorRecords

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Inputs (if any)
## OUTPUTS

### Output (if any)
## NOTES
General notes

## RELATED LINKS
