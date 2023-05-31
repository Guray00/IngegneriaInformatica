import os
import boto3
import json
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding
from urllib.parse import unquote_plus

s3 = boto3.client('s3', region_name='eu-west-1')


def encrypt(msg):
    key = os.urandom(32)
    iv = os.urandom(16)
    
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv))
    encryptor = cipher.encryptor()
    
    padder = padding.PKCS7(algorithms.AES.block_size).padder()
    padded_data = padder.update(msg) + padder.finalize()
    
    ct = encryptor.update(padded_data) + encryptor.finalize()
    
    return cipher, padder, ct
    

def decrypt(cipher, padder, ct):
    decryptor = cipher.decryptor()
    
    padded_res = decryptor.update(ct) + decryptor.finalize()
    
    unpadder = padding.PKCS7(algorithms.AES.block_size).unpadder()
    res = unpadder.update(padded_res) + unpadder.finalize()
    
    return res
    

def lambda_handler(event, context):
    
    cipher_body = bytearray()
    decrypted_body = bytearray()
    
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        old_key = unquote_plus(record['s3']['object']['key'])
        
        response = s3.get_object(Bucket=bucket_name, Key=old_key)
        
        plain_body = response['Body']
        
        for l in plain_body.iter_lines():
            cipher, padder, cl = encrypt(l)
            
            cipher_body.extend(cl)
            
            decrypted_body.extend(decrypt(cipher, padder, cl))
    
        
        crypted_key = f"crypted/{os.path.basename(old_key)}"
        s3.put_object(Bucket=bucket_name, Key=crypted_key, Body=cipher_body)
        
        decrypted_key = f"decrypted/{os.path.basename(old_key)}"
        s3.put_object(Bucket=bucket_name, Key=decrypted_key, Body=decrypted_body)
        
        
        s3.delete_object(Bucket=bucket_name, Key=old_key)
    
    
    return {"plain": str(decrypted_body), 
        "crypt": str(cipher_body)
    }
