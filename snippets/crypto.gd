"""

simple dressup of encryption, be careful as the IV is not supposed to remain secret actually it's supposed to be added to the message
it prevents an attack that can break AES over time if the same key is used

used though for casual encryption just to stop internet snoopers being clued into what the data is, or savegames it might be okay

"""

# simple encryption functions, uses CBC, the best one size fits all choice
# IV must be of exactly 16 bytes...
# note it is not secret, you usually pad them to the front of the message 
# the point of the IV is to not use the same one more than once if you want to be protected from attack
# in the case i use the encryption causually

func simple_encrypt(key, data, iv = "My secret iv!!!!"):
    var aes = AESContext.new()
    aes.start(AESContext.MODE_CBC_ENCRYPT, key.to_utf8_buffer(), iv.to_utf8_buffer())
    var encrypted = aes.update(data.to_utf8_buffer())
    aes.finish()
    return encrypted


func simple_decrypt(key, encrypted_data, iv = "My secret iv!!!!"):
    var aes = AESContext.new()
    aes.start(AESContext.MODE_CBC_ENCRYPT, key.to_utf8_buffer(), iv.to_utf8_buffer())
    var decrypted = aes.update(encrypted_data)
    aes.finish()
    return decrypted
