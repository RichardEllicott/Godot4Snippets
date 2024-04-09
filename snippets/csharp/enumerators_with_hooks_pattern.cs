

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




// alternate more simple method?
Dictionary<String, MethodInfo> _method_cache = new Dictionary<String, MethodInfo>();
public void call_method_string(String action_string)
{
    MethodInfo mi;
    if (_method_cache.TryGetValue(action_string, out mi))
    {
    }
    else
    {
        mi = this.GetType().GetMethod(action_string);
        _method_cache[action_string] = mi;
    }
    if (mi != null)
    {
        mi.Invoke(this, null);
    }
}
