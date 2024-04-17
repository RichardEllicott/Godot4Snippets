// easy set bit flags on an integer
  public static int SetBit(this int i, int position, bool value)
  {
      if (value) return i |= (1 << position); // set bit to 1
      else return i & ~(1 << position);   // set bit to 0
  }

  public static bool GetBit(this int value, int position)
  {
      return (value & (1 << position)) != 0; // get bit at position
  }
