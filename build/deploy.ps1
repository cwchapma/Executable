#Requires -Modules @{ ModuleName = "PowerShellGet"; ModuleVersion = "1.6.6" }

Import-Module PowerShellGet -Force
Import-PackageProvider PowerShellGet -Force

$ModulePath = Join-Path $env:APPVEYOR_BUILD_FOLDER $env:APPVEYOR_PROJECT_NAME
Publish-Module -Path $ModulePath -NuGetApiKey ($env:PSGallery_Api_Key) -Confirm:$false