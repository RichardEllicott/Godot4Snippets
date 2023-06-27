"""

simple dressup of encryption, generates a random IV automaticly and pads to the front of the encrypted data

a sensible method except beware even reasonable password sizes (for servers) might not be for open decrypted data

using a password instead of 32 random bytes for AES can be insecure, which can be avoided with an excessive password size!

expectations should be similar to a password protected zip, which is potentially  vulnerable to brute force attacks

"""




static func get_random_bytes(count: int) -> PackedByteArray:
    randomize()
    var bytes = PackedByteArray()
    bytes.resize(count) 
    for i in count:
        bytes[i] = randi() % 255
    return bytes




## simple encrypt a string with a key, generates and pads the IV internally in the correct way!
## what is not necersarily correct is using a string throgh sha256 for a password
## for true security one would have generate the key as 32 completely random bytes
## this is a "brute force vulnerability", to eliminate it generate a long random password
static func simple_encrypt(data: PackedByteArray, key: PackedByteArray, compress: bool = false) -> PackedByteArray:
    var iv = get_random_bytes(16) # IV is 16 random bytes
    
    if compress:
        data = compress(data)
        
    for i in 16 - data.size() % 16: # ensure string is 16 bytes by adding spaces
        data += PackedByteArray([0])
    var aes: AESContext = AESContext.new()
    aes.start(AESContext.MODE_CBC_ENCRYPT, key, iv)
    var encrypted = aes.update(data)
    aes.finish()
    return iv + encrypted # IV packed publicly to the front of bytes


static func simple_decrypt(encrypted_data: PackedByteArray, key: PackedByteArray, compress: bool = false) -> PackedByteArray:
    var iv: PackedByteArray = encrypted_data.slice(0, 16) # split off the iv
    encrypted_data = encrypted_data.slice(16) # and data
    
    
    var aes: AESContext = AESContext.new()
    aes.start(AESContext.MODE_CBC_DECRYPT, key, iv)
    var decrypted: PackedByteArray = aes.update(encrypted_data)
    aes.finish()
    
    if compress:
        decrypted = decompress(decrypted)
    
    return decrypted
   


## dress up for gzip compress
## it pads the size to the front to avoid needing decompress_dynamic
static func compress(bytes: PackedByteArray) -> PackedByteArray:
    var size_bytes: PackedByteArray = PackedByteArray()
    size_bytes.resize(4)
    size_bytes.encode_u32(0, bytes.size())
    bytes = bytes.compress(3) # only gzip seems to be any good!
    return size_bytes + bytes # put the size bytes to the front

## decompress with same method
static func decompress(bytes: PackedByteArray) -> PackedByteArray:
    var size: int = bytes.slice(0, 4).decode_u32(0) # the first 4 bytes are an u32 integer of size
    bytes = bytes.slice(4) # the remaining bytes are compressed data
    bytes = bytes.decompress(size, 3) # only gzip seems to be any good!
    return bytes


## this hash function ensures the password is a safe 32 bytes
## beware, short passwords are vulnerable, this is secure like zip compression
## which is not very secure if the password is short
# providing 32 characters even would not be quite as random as 32 random bytes for example
static func sha512(input: String):
    var hash = HashingContext.new()
    hash.start(HashingContext.HASH_SHA256)
    hash.update(input.to_ascii_buffer())
    return hash.finish()
    

func macro_test():
    print("macro_test...")
    
    var key = "My secret key!!!" # Key must be either 16 or 32 bytes.
    var data = "Two households, both alike in dignity,
In fair Verona, where we lay our scene,
From ancient grudge break to new mutiny,
Where civil blood makes civil hands unclean."
    
    
    print(data)
    
    data = simple_encrypt(data.to_ascii_buffer(), sha512(key), true)
    
    print(data)
    
    print(data.size())
    
    data = simple_decrypt(data, sha512(key), true)
    
    print(data.get_string_from_utf8())
    




    
    
    
