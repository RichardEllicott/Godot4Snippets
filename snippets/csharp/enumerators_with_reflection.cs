

// this is a common pattern i use with reflection
// the reason is that the enumerator names now control the function names
// it can make organising state machines much easier as the functions called are enforced by convention

// i could have modes like modeA, modeB, modeC
// _process_modeA
// _process_modeB
// _update_modeA

// etc, it allows a convention enforced by the enumerators

public enum Mode
  {
      none,
      normal,
      test,
  }

  Mode mode = 0;

  public string get_enum_string()
  { // get our mode as a string
      return Enum.GetName(typeof(Mode), mode);
  }

  public void call_method_based_on_enum_name()
  {
      string method_name = "_update_" + get_enum_string();
      MethodInfo mi = this.GetType().GetMethod(method_name);
      mi.Invoke(this, null);
  }

  public void _update_normal()
  {
      GD.Print("_update_normal...");
  }
