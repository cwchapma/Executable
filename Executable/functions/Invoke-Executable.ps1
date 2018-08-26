<#
.SYNOPSIS
    Executes a executable file (*.exe) and handles stderr and exit codes
.DESCRIPTION
    By default when powershell runs an executable any output to stderr is converted to an ErrorRecord.
    Many console applications simply write to stderr as a way of separating output from stdout - not because there was an error.
.PARAMETER Command
    The executable command and it's arguments
.PARAMETER AllowableExitCodes
    An array of the allowable exit codes. If the exit code after running the command is not in this list, an exception is thrown.
.PARAMETER StdErrAsErrorRecords
    Indicates lines output to stderr by the command, should be returned as ErrorRecords. 
    By default, this cmdlet converts lines output to stderr to strings that appear as stdout.
.EXAMPLE
    PS C:\> Invoke-Executable "robocopy C:\src C:\dest" -AllowableExitCodes 0,1,2,3,7
    Runs the executable robocopy.exe (presumably to copy C:\src to C:\dest) 
    and will not throw an exception if the exit code is one of 0,1,2,3, or 7
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
#>
function Invoke-Executable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String] $Command,
        [int[]] $AllowableExitCodes = @(0),
        [Switch] $StdErrAsErrorRecords = $false
    )

    Write-Debug "Executing '$Command'"

    # 2>&1 captures stderr in the output but they are still error records
    $output = Invoke-Expression "$Command 2>&1"

    if ($StdErrAsErrorRecords) {
        $output
    } else {
        $output | ForEach-Object { Write-Output $_.ToString() }
    }
    if ($AllowableExitCodes -notcontains $LASTEXITCODE) {
        throw "Exit code '$LASTEXITCODE' not in allowable exit codes '$AllowableExitCodes'. Command: '$Command'"
    }
}