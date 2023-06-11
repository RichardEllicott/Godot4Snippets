"""

finding a public IP, usually should be done by an API like steam etc

"""
## based on:
## https://godotforums.org/d/30360-running-a-command-to-get-a-public-ip-address-from-a-getmyip-site/3




## dress up of a simple http request
func make_http_request(_name: String, url: String, callback: Callable):
    var http = get_node_or_null(_name)
    if not is_instance_valid(http):
        http = HTTPRequest.new()
        add_child(http)
        http.name = _name
    http.request_completed.connect(callback)
    http.request(url)
        
        
## https://godotforums.org/d/30360-running-a-command-to-get-a-public-ip-address-from-a-getmyip-site/3
func macro_get_public_ip():
    make_http_request("IPRequest", "https://api.ipify.org", _on_found_ip)
    
    
func _on_found_ip(result, response_code, headers, body):
    
    if response_code == 200:
        var ip = body.get_string_from_utf8()
        add_to_log("public ip detected: %s" % ip)
        public_ip = ip
    else:
        add_to_log("failed to detect IP!" % response_code)
