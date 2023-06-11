"""

quick dressup of http request

"""


## dress up of a simple http request
func make_http_request(_name: String, url: String, callback: Callable):
    var http = get_node_or_null(_name)
    if not is_instance_valid(http):
        http = HTTPRequest.new()
        add_child(http)
        http.name = _name
    if not http.request_completed.is_connected(callback):
        http.request_completed.connect(callback)
    http.request(url)
  
## callback example 
func _response(result, response_code, headers, body):
  assert(response_code == 200)
