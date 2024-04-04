

    public void macro_test_primes()
    {
        var ps = new PrimesSieve();
        ps.generate();
    }


    // https://gist.github.com/mcmullm2-dcu/648f08f3c4e96e368cbf7f4c47e0cb74
    public class PrimesSieve
    {

        Godot.Collections.Array<int> primes2 = new Godot.Collections.Array<int>();

        public void generate()
        {
            primes2 = new Godot.Collections.Array<int>();

            const int MAX = 1000;
            // Create an array of boolean values indicating whether a number is prime.
            // Start by assuming all numbers are prime by setting them to true.
            bool[] primes = new bool[MAX + 1];
            for (int i = 0; i < primes.Length; i++)
            {
                primes[i] = true;
            }

            // Loop through a portion of the array (up to the square root of MAX). If
            // it's a prime, ensure all multiples of it are set to false, as they
            // clearly cannot be prime.
            for (int i = 2; i < Math.Sqrt(MAX) + 1; i++)
            {
                if (primes[i - 1])
                {
                    for (int j = (int)Math.Pow(i, 2); j <= MAX; j += i)
                    {
                        primes[j - 1] = false;
                    }
                }
            }

            // Output the results
            int count = 0;
            for (int i = 2; i < primes.Length; i++)
            {
                if (primes[i - 1])
                {
                    Console.WriteLine(i);

                    primes2.Add(i);



                    count++;
                }
            }

            GD.Print(primes2);
            // Console.WriteLine($"There are {count} primes up to {MAX}");

        }

    }
