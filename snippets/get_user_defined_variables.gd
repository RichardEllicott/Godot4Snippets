"""
normal list properties lists them all, this just lists user defined ones

"""

static func get_user_defined_variables(_self):
    return _self.get_script().get_script_property_list()
