

// this trick makes the main viewport leave trails as you draw, allowing drawing to part of screen over frames, trails etc
RenderingServer.viewport_set_clear_mode(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_CLEAR_NEVER)
