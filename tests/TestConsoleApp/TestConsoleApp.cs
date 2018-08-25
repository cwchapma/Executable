using System;

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
                Console.WriteLine($"Arg: {arg}");
            }
        }
    }
}
