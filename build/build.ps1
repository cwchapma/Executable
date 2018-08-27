#Requires -Modules @{ ModuleName = "PowerShellGet"; ModuleVersion = "1.6.6" }

$ProjectPath = Split-Path $PSScriptRoot
$ModuleName = Split-Path $ProjectPath -Leaf

# Output to debug versioning issues
gitversion /l console

$gitversion = GitVersion.exe | ConvertFrom-Json

$Version = $gitversion.MajorMinorPatch

$ModulePath = Join-Path $ProjectPath $ModuleName

$params = @{
    Path = "$PSScriptRoot\..\Executable\Executable.psd1"
    ModuleVersion = $Version
    NestedModule = "Executable.psm1"
}
if ($gitversion.PreReleaseTag) {
    $PrereleaseVersion = "-$($gitversion.PreReleaseLabel)$($gitversion.CommitsSinceVersionSourcePadded)"
    "Version: $Version$PrereleaseVersion"
    $params += @{
        Prerelease = $PrereleaseVersion
    }
} else {
    "Version: $Version"
}

Update-ModuleManifest @params

# build help file
$DocsPath = Join-Path $ProjectPath "docs"
$DocsOutPutPath = Join-Path $ModulePath "en-US"
$null = New-Item -ItemType Directory -Path $DocsOutPutPath -Force
$null = New-ExternalHelp -Path $DocsPath -OutPutPath $DocsOutPutPath -Encoding ([System.Text.Encoding]::UTF8) -Force

# run tests
$testResultsFile = ".\TestsResults.xml"
$res = Invoke-Pester `
    -PesterOption @{IncludeVSCodeMarker = $true} `
    -OutputFormat NUnitXml `
    -OutputFile $testResultsFile `
    -PassThru

if ($env:APPVEYOR) {
    (New-Object 'System.Net.WebClient').UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path $testResultsFile))
    if ($res.FailedCount -gt 0) { 
        throw "$($res.FailedCount) tests failed."
    }
}