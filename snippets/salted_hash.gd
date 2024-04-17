
## salted hash is similar to a BCrypt hash, which pads a random number to the hash to prevent certain attacks
## this can allow fingerprinting information, but making it harder to reverse the hash

## generate random pad bytes to set the hash state randomly (to evade attack)
## return the hash along with these random bytes (at the front)
static func salted_hash(data: PackedByteArray, pad: int = 16) -> PackedByteArray:
    var random_bytes: PackedByteArray = get_random_bytes(pad)
    var hash: HashingContext = HashingContext.new()
    hash.start(HashingContext.HASH_SHA256)
    hash.update(random_bytes) # padding the random bytes adds security
    hash.update(data)
    hash.update(random_bytes)
    return random_bytes + hash.finish()
    
## verify our salted hash, we must keep the pad size the same
static  func verify_salted_hash(data: PackedByteArray, hash_bytes: PackedByteArray, pad: int = 16) -> bool:
    
    var hash_bytes_sha = hash_bytes.slice(pad, hash_bytes.size())
    var random_bytes: PackedByteArray = hash_bytes.slice(0, pad)
    var hash: HashingContext = HashingContext.new()
    hash.start(HashingContext.HASH_SHA256)
    hash.update(random_bytes)
    hash.update(data)
    hash.update(random_bytes)
    return hash.finish() == hash_bytes_sha

    
func macro_test():
    
    var string: String = "test me"
    
    var sh: PackedByteArray = salted_hash(string.to_utf8_buffer())

    print("salted hash: ", sh.hex_encode())
    print("verify_salted_hash: ", verify_salted_hash(string.to_utf8_buffer(), sh))
