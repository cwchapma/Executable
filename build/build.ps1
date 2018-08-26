#Requires -Modules @{ ModuleName = "PowerShellGet"; ModuleVersion = "1.6.6" }

$ProjectPath = Split-Path $PSScriptRoot
$ModuleName = Split-Path $ProjectPath -Leaf

# Output to debug versioning issues
gitversion /l console

$gitversion = GitVersion.exe | ConvertFrom-Json

$Version = $gitversion.MajorMinorPatch

$TestExit = [boolean]($env:APPVEYOR)
"TestExit: $TestExit"

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
Invoke-Pester -EnableExit:$TestExit -PesterOption @{IncludeVSCodeMarker = $true}