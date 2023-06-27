"""

simple dressup of encryption, generates a random IV automaticly and pads to the front of the encrypted data

"""





## simple encrypt a string with a key, generates and pads the IV internally in the correct way!
## what is not necersarily correct is using a string throgh sha256 for a password
## for true security one would have generate the key as 32 completely random bytes
## this is a "brute force vulnerability", to eliminate it generate a long random password
func simple_encrypt(data: String, key: String = "My secret key!!!") -> PackedByteArray:
    var iv = get_random_bytes(16) # IV is 16 random bytes
    for i in 16 - data.length() % 16: # ensure string is 16 bytes by adding spaces
        data += " "
    var aes: AESContext = AESContext.new()
    aes.start(AESContext.MODE_CBC_ENCRYPT, sha512(key), iv)
    var encrypted = aes.update(data.to_ascii_buffer())
    aes.finish()
    return iv + encrypted # IV packed publicly to the front of bytes


func simple_decrypt(encrypted_data: PackedByteArray, key: String = "My secret key!!!") -> String:
    var iv: PackedByteArray = encrypted_data.slice(0, 16) # split off the iv
    encrypted_data = encrypted_data.slice(16) # and data
    var aes: AESContext = AESContext.new()
    aes.start(AESContext.MODE_CBC_DECRYPT, sha512(key), iv)
    var decrypted: PackedByteArray = aes.update(encrypted_data)
    aes.finish()
    return decrypted.get_string_from_utf8()
   
 
## this hash function ensures the password is a safe 32 bytes
## beware, short passwords are vulnerable, this is secure like zip compression
## which is not very secure if the password is short
# providing 32 characters even would not be quite as random as 32 random bytes for example
func sha512(input: String):
    var hash = HashingContext.new()
    hash.start(HashingContext.HASH_SHA256)
    hash.update(input.to_ascii_buffer())
    return hash.finish()
    

func macro_test():
    print("macro_test...")
    
    var key = "My secret key!!!" # Key must be either 16 or 32 bytes.
    var data = "My secret textsss!!"
    
    print(data)
    
    data = simple_encrypt(data, key)
    
    print(Marshalls.raw_to_base64(data))
    
    data = simple_decrypt(data, key)
    
    print(data)





    
    
    
