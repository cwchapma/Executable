# Executable

Easily execute executables (*.exe), check the exit code, and handle output to stderr

[![Build status](https://ci.appveyor.com/api/projects/status/dktthvk43gwicc7l?svg=true)](https://ci.appveyor.com/project/cwchapma/Executable)

[![AppVeyor tests](https://img.shields.io/appveyor/tests/cwchapma/Executable.svg)](https://ci.appveyor.com/project/cwchapma/executable/build/tests)

[![latest version](https://img.shields.io/powershellgallery/v/Executable.svg?label=latest+version)](https://www.powershellgallery.com/packages/Executable)

## Features

- Defaults to redirecting stderr to stdout (so order is maintained)
- Throws if exit code is non-zero (can specify -AllowableExitCodes)
- Always waits for the command to finish before returning (powershell doesn't unless you explicity capture the output)

## Why?

Many executables (*.exe) output to stderr, not as a way to indicate an error, but as a way of making it possible to separate streams of output.  Powershell on the other hand, thinks anything output to stderr is in fact an error and creates and ErrorRecord from the output.  This ErrorRecord shows up in red, and will terminate if $ErrorActionPreference is 'Stop'.  This module attempts to alleviate the pain of interacting with executables in Powershell.

## Installation

`Install-Module` requires the NuGet PackageProvider 2.8.5.201 or higher

```powershell
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
```

To install the module:

```powershell
Install-Module Executable
```

Once the module is installed, you must also import it:

```powershell
Import-Module Executable
```

## Usage

Example:

```powershell
Invoke-Executable "git pull"
```

or with the `exec` alias:

```powershell
exec "robocopy C:\source C:\destination" --AllowableExitCodes 0,1,3
```

For more options: [Invoke-Executable](docs/Invoke-Executable.md)

## Contributions are welcome

There are many ways to contribute:

1. Open a new bug report, feature request or just ask a question by opening a new issue here.
2. Participate in the discussions of issues, pull requests and verify/test fixes or new features.
3. Submit your own fixes or features as a pull request but please discuss it beforehand in an issue if the change is substantial.
4. Submit test cases.