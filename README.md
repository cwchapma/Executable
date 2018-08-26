# Executable

Easily execute executables (*.exe), check the exit code, and handle output to stderr

[![Build status](https://ci.appveyor.com/api/projects/status/dktthvk43gwicc7l?svg=true)](https://ci.appveyor.com/project/cwchapma/Executable)

[![latest version](https://img.shields.io/powershellgallery/v/Executable.svg?label=latest+version)](https://www.powershellgallery.com/packages/Executable)

## Features

- Defaults to redirecting stderr to stdout (so order is maintained)
- Throws if exit code is non-zero (can specify -AllowableExitCodes)
- Always waits for the command to finish before returning (powershell doesn't unless you explicity capture the output)

## Why?

Many executables (*.exe) output to stderr, not as a way to indicate an error, but as a way of making it possible to separate streams of output.  Powershell on the other hand, thinks anything output to stderr is in fact an error and creates and ErrorRecord from the output.  This ErrorRecord shows up in red, and will terminate if $ErrorActionPreference is 'Stop'.  This module attempts to alleviate the pain of interacting with executables in Powershell.

## Installation

To install

```powershell
Install-Module Executable
```

## Usage

See [Invoke-Executable](docs/Invoke-Executable.md)

## Contributions are welcome

There are many ways to contribute:

1. Open a new bug report, feature request or just ask a question by opening a new issue here.
2. Participate in the discussions of issues, pull requests and verify/test fixes or new features.
3. Submit your own fixes or features as a pull request but please discuss it beforehand in an issue if the change is substantial.
4. Submit test cases.