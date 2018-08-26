using System;
using System.Text.RegularExpressions;

namespace test
{
    class Program
    {
        static void Main(string[] args)
        {
            // Output to stdout because "everybody's doing it"
            Console.WriteLine("Hello from stdout!");

            // Output to stderr so we can check this doesn't cause a powershell error
            Console.Error.WriteLine("Hello from stderr!");

            // Output args so we can test they are passed properly
            foreach (var arg in args) {
                if (arg.StartsWith("exitcode:")) {
                    var match = Regex.Match(arg, @"exitcode:(-?\d+)");
                    if (match.Success) {
                        var exitcode = int.Parse(match.Groups[1].Value);
                        Environment.ExitCode = exitcode;
                    } else {
                        throw new Exception($"exitcode '{arg.Substring(9)}' is not an int. 'exitcode:...' arg should only be used as a way to set the exitcode");
                    }
                }
                Console.WriteLine($"Arg: {arg}");
            }
        }
    }
}
