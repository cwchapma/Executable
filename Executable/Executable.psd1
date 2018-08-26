@{
	NestedModules = "Executable.psm1"
	ModuleVersion = "0.2.0"
	GUID = "c4e893ac-fb28-4881-bb77-6df31b69c041"
	Author = "Clint Chapman"
	Copyright = "(c) 2018. All rights reserved."
	Description = "Invoke-Executable for running executables with control over stderr"
	PowerShellVersion = "3.0"
	FunctionsToExport = @(
		"Invoke-Executable"
	)
	AliasesToExport = @(
		"exec"
	)
	PrivateData = @{
        PSData = @{
            Tags = @('executable','exe','commandline')
            LicenseUri = "https://github.com/cwchapma/Executable/blob/master/Executable/license"
            ProjectUri = "https://github.com/cwchapma/Executable"
            ReleaseNotes = "Add support for specifying allowable exit codes"
        }
    }
}

