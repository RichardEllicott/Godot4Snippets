"""

finding a public IP, usually should be done by an API like steam etc

"""
## based on:
## https://godotforums.org/d/30360-running-a-command-to-get-a-public-ip-address-from-a-getmyip-site/3

func macro_check_ip():
    
    # these are local
    for address in IP.get_local_addresses():
        if (address.split('.').size() == 4):            
            print(address)
    

    var http = HTTPRequest.new()
    add_child(http)
    http.request_completed.connect(print_ip)
    http.request("https://api.ipify.org")
    
func print_ip(result, response_code, headers, body):
    var ip = body.get_string_from_utf8()
    print("Internet IP is: ", ip)
