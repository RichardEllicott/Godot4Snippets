"""

awkward to type/edit sometimes, lifted this out of Zylanns Planet Atmosphere shader



just scaps... 

"""


func set_shader_parameter(param_name: StringName, value):
    _get_material().set_shader_parameter(param_name, value)


func get_shader_parameter(param_name: StringName):
    return _get_material().get_shader_parameter(param_name)


# Shader parameters are exposed like this so we can have more custom shaders in the future,
# without forcing to change the node/script entirely
func _get_property_list():
    var props := []
    var mat := _get_material()
    var shader_params := RenderingServer.get_shader_parameter_list(mat.shader.get_rid())
    for p in shader_params:
        if _api_shader_params.has(p.name):
            continue
        var cp := {}
        for k in p:
            cp[k] = p[k]
        cp.name = str("shader_params/", p.name)
        props.append(cp)
    return props
