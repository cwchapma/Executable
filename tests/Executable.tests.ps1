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

dotnet build --configuration Release --runtime win-x64 $PSScriptRoot\TestConsoleApp

Describe 'Invoke-Executable' {
    $cmd = "$PSScriptRoot\TestConsoleApp\bin\Release\netcoreapp2.0\win-x64\TestConsoleApp.exe"

    It "Returns stdout" {
        $output = Invoke-Executable $cmd
        $output | Should -Contain 'Hello from stdout!'
    }

    It 'Returns stderr as string' {
        $output = Invoke-Executable $cmd
        $output | Should -BeOfType String
        $output | Should -Contain 'Hello from stderr!'
    }

    It 'Return stderr as ErrorRecord when -StdErrAsErrorRecords' {
        $output = Invoke-Executable $cmd -StdErrAsErrorRecords
        $output[1] | Should -BeOfType System.Management.Automation.ErrorRecord
        $output[1].TargetObject | Should -Be 'Hello from stderr!'
        $output[1].FullyQualifiedErrorId | Should -Be "NativeCommandError"
    }

    It 'Passes args properly' {
        $output = Invoke-Executable "$cmd arg1 arg2"
        $output | Should -Contain 'Arg: arg1'
        $output | Should -Contain 'Arg: arg2'
    }

    It 'Outputs in the right order' {
        $output = Invoke-Executable "$cmd arg1 arg2"
        $output | Should -Be "Hello from stdout!", "Hello from stderr!", "Arg: arg1", "Arg: arg2"
    }

}