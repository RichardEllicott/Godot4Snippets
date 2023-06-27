"""

simple dressup of encryption, generates a random IV automaticly and pads to the front of the encrypted data

"""





func simple_encrypt(data: String, key = "My secret key!!!") -> PackedByteArray:
    
    var iv = get_random_bytes(16) # IV is 16 random bytes
    
    for i in 16 - data.length() % 16: # ensure string is 16 bytes by adding spaces
        data += " "
        
    var aes: AESContext = AESContext.new()
    aes.start(AESContext.MODE_CBC_ENCRYPT, key.to_ascii_buffer(), iv)
    var encrypted = aes.update(data.to_ascii_buffer())
    aes.finish()
    return iv + encrypted # IV packed publicly to the front of bytes


func simple_decrypt(encrypted_data: PackedByteArray, key = "My secret key!!!") -> String:
    var iv: PackedByteArray = encrypted_data.slice(0, 16) # split off the iv
    encrypted_data = encrypted_data.slice(16) # and data
    var aes: AESContext = AESContext.new()
    aes.start(AESContext.MODE_CBC_DECRYPT, key.to_ascii_buffer(), iv)
    var decrypted: PackedByteArray = aes.update(encrypted_data)
    aes.finish()
    return decrypted.get_string_from_utf8()
    
    

func macro_test():
    print("macro_test...")
    
    var key = "My secret key!!!" # Key must be either 16 or 32 bytes.
    var data = "My secret textsss!!"
    
    print(data)
    
    data = simple_encrypt(data, key)
    
    print(Marshalls.raw_to_base64(data))
    
    data = simple_decrypt(data, key)
    
    print(data)





    
    
    
