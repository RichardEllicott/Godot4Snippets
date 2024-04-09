

// reflection pattern where names of enums determine functions that are called

public enum Mode
  {
      none,
      normal,
      test,
  }

  [Export]
  Mode mode = 0;

  int last_mode = -1;

  MethodInfo mi;

  public void update_hooks() // update all the loops here, you could have others for process etc
  {
      if (last_mode != (int)mode)
      {
          last_mode = (int)mode;
          string enum_string = get_enum_string();
          var update_method_name = "_update_" + enum_string;
          mi = this.GetType().GetMethod(update_method_name); // nul if invalid
      }
  }

  public string get_enum_string() // get our mode as a string
  {
      return Enum.GetName(typeof(Mode), mode);
  }


  public void _Update()
  {
      update_hooks();

      if (mi != null)
      {
          mi.Invoke(this, null);
      }
