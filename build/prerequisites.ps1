Install-PackageProvider -Name NuGet -Confirm:$false -Force -ErrorAction Stop | Out-Null
Install-Module -Name Pester, PSScriptAnalyzer, PlatyPS -Confirm:$false -Force -ErrorAction Continue -SkipPublisherCheck | Out-Null
choco install gitversion.portable -pre -y | Out-Default

# Required for Update-ModuleManifest with -Prerelase parameter
Install-Module PowerShellGet -MinimumVersion 1.6.6 -Force