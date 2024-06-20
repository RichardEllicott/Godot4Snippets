/*

showing a manual version of random normals

i could add the probabaility function, just done it anyway (even though it exists already)

*/



  public static Vector3 RandFnVector3(this Godot.RandomNumberGenerator random)
  {
      return new Vector3(random.Randfn(0.0f, 1.0f), random.Randfn(0.0f, 1.0f), random.Randfn(0.0f, 1.0f));
  }

  //
  public static Vector3 RandFnVector3(this Random random)
  {
      var ran1 = Normal2D(random);
      var ran2 = Normal2D(random);
      return new Vector3(ran1.X, ran1.Y, ran2.X);
  }


  // i have this manual to prove it's possible
  //
  // based on non Box-Muller at top of this page:
  // https://www.taygeta.com/random/gaussian.html
  // this doc is wrong (as it is old), the top one is faster on a modern computer (i tested it)!!
  // fastest and best i found, to make it 3D, call it more than once!
  public static Vector2 Normal2D(Random random)
  {
      float al1 = MathF.Sqrt(-2.0f * MathF.Log(random.NextSingle()));
      float al2 = 2.0f * (float)Math.PI * random.NextSingle();

      float x = al1 * MathF.Cos(al2);
      float y = al1 * MathF.Sin(al2);

      return new Vector2(x, y);
  }
