Install-PackageProvider -Name NuGet -Confirm:$false -Force -ErrorAction Stop 
Install-Module -Name Pester, PSScriptAnalyzer, PlatyPS -Confirm:$false -Force -ErrorAction Continue -SkipPublisherCheck
# Required for Update-ModuleManifest with -Prerelase parameter
Install-Module PowerShellGet -MinimumVersion 1.6.6 -Force

choco install gitversion.portable --no-progress --limit-output --prerelease -y | Out-Default