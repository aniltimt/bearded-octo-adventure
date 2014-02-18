require "base64"
require "openssl"
require 'digest/md5'

module EncryptDecryptData

  #sample commands for generating keys
  #generate key pair
  #openssl genrsa -des3 -out private.pem 2048
  #openssl genrsa -out private.pem 2048
  #extract public key
  #openssl rsa -in private.pem -out public.pem -outform PEM -pubout

  def encrypt_confidential_data(data)
    public_key = OpenSSL::PKey::RSA.new(File.read('public.pem'))
    cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
    cipher.encrypt
    cipher.key = random_key = cipher.random_key
    cipher.iv = random_iv = cipher.random_iv

    _data = cipher.update(data)
    _data << cipher.final
    thekey = public_key.public_encrypt(random_key)
    theiv = public_key.public_encrypt(random_iv)

    _encrypted_data = thekey64 = Base64.encode64(thekey)
    _encrypted_data << "+++000"
    _encrypted_data << Base64.encode64(theiv)
    _encrypted_data << "+++000"
    _encrypted_data << Base64.encode64(_data)
    return _encrypted_data
  end

  def decrypt_confidential_data(ciphertext)
    a = ciphertext.split("+++000")
    decrypt(Base64.decode64(a[2]),Base64.decode64(a[0]),Base64.decode64(a[1]))
  end

  def decrypt(data,encrypted_key,encrypted_iv)
#    private_key = OpenSSL::PKey::RSA.new(File.read(PRIVATE_KEY))
    private_key = OpenSSL::PKey::RSA.new(File.read("private.pem"),"clu2@12")

    cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
    cipher.decrypt
    cipher.key = private_key.private_decrypt(encrypted_key)

    cipher.iv = private_key.private_decrypt(encrypted_iv)

    decrypted_data = cipher.update(data)
    decrypted_data << cipher.final
  end

  def generate_hash_for_confidential_data(data)
    CfscardCard.get_hash_value(data)
  end

end
