import math
import time
import random
import sympy
import warnings
from random import randint, seed
import sys
from ecpy.curves import Curve,Point
from Crypto.Hash import SHA3_256, HMAC, SHA256
import requests
from Crypto.Cipher import AES
from Crypto import Random
from Crypto.Util.Padding import pad
from Crypto.Util.Padding import unpad
import random
import re
import json
import hashlib

API_URL = 'http://harpoon1.sabanciuniv.edu:9999'



def IKRegReq(h,s,x,y):
    mes = {'ID':stuID, 'H': h, 'S': s, 'IKPUB.X': x, 'IKPUB.Y': y}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "IKRegReq"), json = mes)		
    print(response.json())

def IKRegVerify(code):
    mes = {'ID':stuID, 'CODE': code}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "IKRegVerif"), json = mes)
    if((response.ok) == False): raise Exception(response.json())
    else:
        print(response.json())
        f = open('Identity_Key.txt', 'w')
        f.write("IK.Prv: "+str(IKey_Pr)+"\n"+"IK.Pub.x: "+str(IKey_Pub.x)+"\n"+"IK.Pub.y: "+str(IKey_Pub.y))
        f.close()

def SPKReg(h,s,x,y):
    mes = {'ID':stuID, 'H': h, 'S': s, 'SPKPUB.X': x, 'SPKPUB.Y': y}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "SPKReg"), json = mes)
    print(response.json())	

def OTKReg(keyID,x,y,hmac):
    mes = {'ID':stuID, 'KEYID': keyID, 'OTKI.X': x, 'OTKI.Y': y, 'HMACI': hmac}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "OTKReg"), json = mes)		
    print(response.json())
    if((response.ok) == False): return False
    else: return True


def ResetIK(rcode):
    mes = {'ID':stuID, 'RCODE': rcode}
    print("Sending message is: ", mes)
    response = requests.delete('{}/{}'.format(API_URL, "ResetIK"), json = mes)		
    print(response.json())
    if((response.ok) == False): return False
    else: return True

def ResetSPK(h,s):
    mes = {'ID':stuID, 'H': h, 'S': s}
    print("Sending message is: ", mes)
    response = requests.delete('{}/{}'.format(API_URL, "ResetSPK"), json = mes)		
    print(response.json())
    if((response.ok) == False): return False
    else: return True


def ResetOTK(h,s):
    mes = {'ID':stuID, 'H': h, 'S': s}
    print("Sending message is: ", mes)
    response = requests.delete('{}/{}'.format(API_URL, "ResetOTK"), json = mes)		
    if((response.ok) == False): print(response.json())

## My Implementation

# Generate a public key from a private key
def keyGen(cv: Curve, sA: int):
    return sA, sA * cv.generator

# Generate a signature based on a message and a private key
def sigGen(cv: Curve, m, sA: int):
    n = cv.order
    
    k = randint(1, n-2)
    
    R = k * cv.generator
    r = R.x % n

    r_bytes = r.to_bytes((r.bit_length() + 7) // 8, byteorder='big')
    if isinstance(m, str):
        m_bytes = str(m).encode("utf-8")
    elif isinstance(m, int):
        m_bytes = m.to_bytes((m.bit_length() + 7) // 8, byteorder='big')
    elif isinstance(m, bytes):
        m_bytes = m
    concatenated = r_bytes + m_bytes
    h = int.from_bytes(SHA3_256.new(concatenated).digest(), "big") % n
    s = (k - sA * h) % n
    return h, s

# Verify a signature based on a message, a public key and a signature
def sigVer(cv: Curve, Q: Point, tp: tuple, m):
    n = cv.order
    h, s = tp
    if not (0 < h < n-1 and 0 < s < n-1):
        return False
    
    V = s * cv.generator + h * Q   
    v = V.x % n
    v_bytes = v.to_bytes((v.bit_length() + 7) // 8, byteorder='big')
    if isinstance(m, str):
        m_bytes = str(m).encode("utf-8")
    elif isinstance(m, int):
        m_bytes = m.to_bytes((m.bit_length() + 7) // 8, byteorder='big')
    elif isinstance(m, bytes):
        m_bytes = m
    concatenated = v_bytes + m_bytes
    h_ = int.from_bytes(SHA3_256.new(concatenated).digest()) % n
    return h == h_


### Select Curve
cv = Curve.get_curve('secp256k1')

stuID = 27970
#Server's Identitiy public key
IKey_Ser = Point(0x1d42d0b0e55ccba0dd86df9f32f44c4efd7cbcdbbb7f36fd38b2ca680ab126e9, \
                 0xce091928fa3738dc18f529bf269ade830eeb78672244fd2bdfbadcb26c4894ff, \
                 Curve.get_curve('secp256k1'))

### Identity key generation

sA = randint(1, cv.order-2)
IKey_Pr, IKey_Pub = keyGen(cv, sA)

print("Identity Key is created\n", \
        "IKey is a long term key and shouldn't be changed and private part should be kept secret."
        "But this is a sample run, so here is my private IKey:\n", IKey_Pr, "\n",\
        "Here is my public IKey:\n", IKey_Pub, "\n", \
        "My ID number is ", stuID, "\n", \
        "Converted my ID to bytes in order to sign it: ", stuID.to_bytes((stuID.bit_length() + 7) // 8, byteorder="big"), sep="")

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

h, s = sigGen(cv, stuID, sA)

print("Local Verification:",sigVer(cv, IKey_Pub, (h, s), stuID))
print("Signature of my ID number is:\n", "h= ", h, "\n", "s= ", s, sep="")
print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

print("Sending signature and my IKEY to server via IKRegReq() function in json format")
IKRegReq(h, s, IKey_Pub.x,IKey_Pub.y)

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

### Enter verification code
code = int(input("Enter verification code which is sent to you: "))


print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

print("Sending verification code to server via IKRegVerify() function in json format")
IKRegVerify(code)

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

### Enter reset code
rcode = int(input("Enter reset code which is sent to you: "))

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

### SPK generation
spkA = randint(1, cv.order-2)
spkA, spkPub = keyGen(cv, spkA)

print("Generating SPK...")
print("Private SPK:", spkA)
print("Public SPK.x:", spkPub.x)
print("Public SPK.y:", spkPub.y)

x, y = spkPub.x, spkPub.y
mx, my = x.to_bytes((x.bit_length() + 7) // 8, byteorder='big'), y.to_bytes((y.bit_length() + 7) // 8, byteorder='big')
spk_m = mx + my

print("Convert SPK.x and SPK.y to bytes in order to sign them then concatenate them")
print("Result will be like:", spk_m)

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

spk_h, spk_s = sigGen(cv, spk_m, sA)

print("Signature of SPK is:")
print("h= ", spk_h, "\n", "s= ", spk_s, sep="")
print("Sending SPK and the signatures to the server via SPKReg() function in json format...")

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
### Register SPK
SPKReg(spk_h, spk_s, spkPub.x, spkPub.y)

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")


### OTK generation
T = spkA * IKey_Ser
ux, uy = T.x.to_bytes((T.x.bit_length() + 7) // 8, byteorder='big'), T.y.to_bytes((T.y.bit_length() + 7) // 8, byteorder='big')
U = b'TheHMACKeyToSuccess' + uy + ux
HMAC_key = int.from_bytes(SHA3_256.new(U).digest(), "big") % cv.order
HMAC_key_bytes = HMAC_key.to_bytes((HMAC_key.bit_length() + 7) // 8, byteorder='big')

print("Creating HMAC key (Diffie Hellman)")
print("T is", T)
print("U is", U)
print("HMAC key is created", HMAC_key_bytes)

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

print("Creating OTKs starting from index 0...")

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

### Register OTKs
for i in range(10):
    otk_k = randint(1, cv.order-2)
    otk_k, otk_pub = keyGen(cv, otk_k)
    print(i, "th key generated. Private part=", otk_k, sep="")
    print("Public (x coordinate)=", otk_pub.x, sep="")
    print("Public (y coordinate)=", otk_pub.y, sep="")
    x, y = otk_pub.x, otk_pub.y
    mx, my = x.to_bytes((x.bit_length() + 7) // 8, byteorder='big'), y.to_bytes((y.bit_length() + 7) // 8, byteorder='big')
    otk_m = mx + my
    print("x and y coordinates of the OTK converted to bytes and concatanated")
    print("Message", otk_m)
    otk_hmac = HMAC.new(HMAC_key_bytes, otk_m, SHA256)
    otk_hmac_hex = otk_hmac.hexdigest()
    print("HMAC is calculated and converted with 'hexdigest()':")
    print(otk_hmac_hex)
    OTKReg(i, x, y, otk_hmac_hex)

    print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

print("Key memory is full. There are 10 keys registered. No need to register more keys")
print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
print("OTK keys were generated successfully!")
print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

# ### reset OTK
# spkDelH, spkDelS = sigGen(cv, stuID, sA)
# print("Trying to delete OTKs...")
# ResetOTK(spkDelH, spkDelS)
# print("All OTKs deleted !")

# print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
# ### reset SPK
# print("Trying to delete SPK...")
# ResetSPK(spkDelH, spkDelS)

# print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
# ### reset IK
# print("Trying to delete IK...")
# ResetIK(rcode)


