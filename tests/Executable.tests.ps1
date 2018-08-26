$ProjectPath = Split-Path $PSScriptRoot

if ($env:APPVEYOR)
{
    $ModuleName = $env:Appveyor_Project_Name
}
else
{
    $ModuleName = Split-Path $ProjectPath -Leaf
}

$ModulePath = Join-Path $ProjectPath $ModuleName
Import-Module $ModulePath -Force

Describe 'TestConsoleApp' {
    It 'builds' {
        dotnet build --configuration Release --runtime win-x64 $PSScriptRoot\TestConsoleApp
        $LASTEXITCODE | Should -Be 0
    }
}

Describe 'Invoke-Executable' {
    # TestConsoleApp is an console app that writes to stdout, stderr
    # and allows setting the exit code with a 'exitcode:<number>' argument
    $cmd = "$PSScriptRoot\TestConsoleApp\bin\Release\netcoreapp2.0\win-x64\TestConsoleApp.exe"

    It 'returns stdout' {
        $LASTEXITCODE = $null
        $output = Invoke-Executable $cmd
        $output | Should -Contain 'Hello from stdout!'
    }

    It 'returns stderr as string' {
        $output = Invoke-Executable $cmd
        $output | Should -BeOfType String
        $output | Should -Contain 'Hello from stderr!'
    }

    It 'return stderr as ErrorRecord when -StdErrAsErrorRecords' {
        $output = Invoke-Executable $cmd -StdErrAsErrorRecords
        $output[0] | Should -BeOfType String
        $output[1] | Should -BeOfType System.Management.Automation.ErrorRecord
        $output[1].TargetObject | Should -Be 'Hello from stderr!'
        $output[1].FullyQualifiedErrorId | Should -Be "NativeCommandError"
    }

    It 'passes args properly' {
        $output = Invoke-Executable "$cmd arg1 arg2"
        $output | Should -Contain 'Arg: arg1'
        $output | Should -Contain 'Arg: arg2'
    }

    # Apparently the order is not reliable and this fails intermittently
    # It 'outputs in the right order' {
    #     $output = Invoke-Executable "$cmd arg1 arg2"
    #     $output | Should -Be "Hello from stdout!", "Hello from stderr!", "Arg: arg1", "Arg: arg2"
    # }

    It 'handles paths as args' {
        $output = Invoke-Executable "$cmd 'c:\this is a\test'"
        $output[2] | Should -Be "Arg: c:\this is a\test"
    }

    It 'handles \n in a path arg' {
        $output = Invoke-Executable "$cmd 'c:\this is a\nother test'"
        $output[2] | Should -Be "Arg: c:\this is a\nother test"
    }

    It 'throws exception when exitcode is 1' {
        { Invoke-Executable "$cmd exitcode:1" } | Should -Throw
    }

    It 'throws exception when exitcode is -1' {
        { Invoke-Executable "$cmd exitcode:-1" } | Should -Throw
    }

    It 'does not throw if exitcode is -1 but allowable' {
        Invoke-Executable "$cmd exitcode:-1" -AllowableExitCodes 0,-1
    }

    It 'throws exception when exitcode is 0 but not allowable' {
        { Invoke-Executable "$cmd exitcode:-1" -AllowableExitCodes 1 } | Should -Throw
    }

    It 'allows double digit exit code' {
        Invoke-Executable "$cmd exitcode:10" -AllowableExitCodes 10
    }

    It 'accepts command from input' {
        "$cmd" | Invoke-Executable
    }

    It 'accepts multiple commands from input' {
        $output = "$cmd run1", "$cmd run2" | Invoke-Executable
        $output | Should -Contain "Arg: run1"
        $output | Should -Contain "Arg: run2"
    }

    It 'supports -ErrorVariable' {
        $output = Invoke-Executable $cmd -ErrorVariable "MyErrors"
        $output | Should -Contain "Hello from stderr!"
        $MyErrors[0].TargetObject | Should -Contain "Hello from stderr!"
    }

    It 'supports -ErrorVariable with -StdErrAsErrorRecords' {
        $output = Invoke-Executable $cmd -ErrorVariable "MyErrors" -StdErrAsErrorRecords
        $output[1] | Should -BeOfType System.Management.Automation.ErrorRecord
        $output[1].TargetObject | Should -Be "Hello from stderr!"
        $MyErrors[0].TargetObject | Should -Contain "Hello from stderr!"
    }

    It 'supports exec alias' {
        $output = exec $cmd
        $output | Should -Contain 'Hello from stdout!'
    }

    It 'does NOT throw when $ErrorAction is ''Stop''' {        
        Invoke-Executable $cmd -ErrorAction 'Stop'
    }
}