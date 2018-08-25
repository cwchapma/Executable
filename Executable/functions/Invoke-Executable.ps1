function Invoke-Executable {
    [CmdletBinding()]
    param (
        [String] $Command,
        [Switch] $StdErrAsErrorRecords = $false
    )
    Write-Debug "Executing '$Command'"

    # 2>&1 captures stderr in the output but they are still error records
    $output = Invoke-Expression "$Command 2>&1"

    if ($StdErrAsErrorRecords) {
        return $output
    } else {
        $output | ForEach-Object { Write-Output $_.ToString() }
    }
}