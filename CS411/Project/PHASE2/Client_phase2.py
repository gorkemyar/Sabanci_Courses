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

API_URL = 'http://harpoon1.sabanciuniv.edu:9999/'

stuID = 27970
stuIDB = 18007
curve = Curve.get_curve('secp256k1')

def egcd(a, b):
    x,y, u,v = 0,1, 1,0
    while a != 0:
        q, r = b//a, b%a
        m, n = x-u*q, y-v*q
        b,a, x,y, u,v = a,r, u,v, m,n
    gcd = b
    return gcd, x, y

def modinv(a, m):
    gcd, x, y = egcd(a, m)
    if gcd != 1:
        return None  # modular inverse does not exist
    else:
        return x % m

def Setup():
    E = Curve.get_curve('secp256k1')
    return E

def KeyGen(E):
    n = E.order
    P = E.generator
    sA = randint(1,n-1)
    QA = sA*P
    return sA, QA

def SignGen(message, E, sA):
    n = E.order
    P = E.generator
    k = randint(1, n-2)
    R = k*P
    r = R.x % n
    h = int.from_bytes(SHA3_256.new(r.to_bytes((r.bit_length()+7)//8, byteorder='big')+message).digest(), byteorder='big')%n
    s = (k - sA*h) % n
    return h, s

def SignVer(message, h, s, E, QA):
    n = E.order
    P = E.generator
    V = s*P + h*QA
    v = V.x % n
    h_ = int.from_bytes(SHA3_256.new(v.to_bytes((v.bit_length()+7)//8, byteorder='big')+message).digest(), byteorder='big')%n
    if h_ == h:
        return True
    else:
        return False


#server's Identitiy public key
IKey_Ser = Point(13235124847535533099468356850397783155412919701096209585248805345836420638441, 93192522080143207888898588123297137412359674872998361245305696362578896786687, curve)

def IKRegReq(h,s,x,y):
    mes = {'ID':stuID, 'H': h, 'S': s, 'IKPUB.X': x, 'IKPUB.Y': y}
    #print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "IKRegReq"), json = mes)		
    print(response.json())

def IKRegVerify(code):
    mes = {'ID':stuID, 'CODE': code}
    #print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "IKRegVerif"), json = mes)
    if((response.ok) == False): raise Exception(response.json())
    print(response.json())

def SPKReg(h,s,x,y):
    mes = {'ID':stuID, 'H': h, 'S': s, 'SPKPUB.X': x, 'SPKPUB.Y': y}
    #print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "SPKReg"), json = mes)		
    print(response.json())

def OTKReg(keyID,x,y,hmac):
    mes = {'ID':stuID, 'KEYID': keyID, 'OTKI.X': x, 'OTKI.Y': y, 'HMACI': hmac}
    #print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "OTKReg"), json = mes)		
    print(response.json())
    if((response.ok) == False): return False
    else: return True


def ResetIK(rcode):
    mes = {'ID':stuID, 'RCODE': rcode}
    #print("Sending message is: ", mes)
    response = requests.delete('{}/{}'.format(API_URL, "ResetIK"), json = mes)		
    print(response.json())
    if((response.ok) == False): return False
    else: return True

def ResetSPK(h,s):
    mes = {'ID':stuID, 'H': h, 'S': s}
    #print("Sending message is: ", mes)
    response = requests.delete('{}/{}'.format(API_URL, "ResetSPK"), json = mes)		
    print(response.json())
    if((response.ok) == False): return False
    else: return True

def ResetOTK(h,s):
    mes = {'ID':stuID, 'H': h, 'S': s}
    #print("Sending message is: ", mes)
    response = requests.delete('{}/{}'.format(API_URL, "ResetOTK"), json = mes)		
    print(response.json())

############## The new functions of phase 2 ###############

#Pseudo-client will send you 5 messages to your inbox via server when you call this function
def PseudoSendMsg(h,s):
    mes = {'ID':stuID, 'H': h, 'S': s}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "PseudoSendMsg"), json = mes)		
    print(response.json())

#Get your messages. server will send 1 message from your inbox
def ReqMsg(h,s):
    mes = {'ID':stuID, 'H': h, 'S': s}
    print("Sending message is: ", mes)
    response = requests.get('{}/{}'.format(API_URL, "ReqMsg"), json = mes)	
    print(response.json())	
    if((response.ok) == True): 
        res = response.json()
        return res["IDB"], res["OTKID"], res["MSGID"], res["MSG"], res["IK.X"], res["IK.Y"], res["EK.X"], res["EK.Y"]

#Get the list of the deleted messages' ids.
def ReqDelMsg(h,s):
    mes = {'ID':stuID, 'H': h, 'S': s}
    print("Sending message is: ", mes)
    response = requests.get('{}/{}'.format(API_URL, "ReqDelMsgs"), json = mes)      
    print(response.json())      
    if((response.ok) == True): 
        res = response.json()
        return res["MSGID"]

#If you decrypted the message, send back the plaintext for checking
def Checker(stuID, stuIDB, msgID, decmsg):
    mes = {'IDA':stuID, 'IDB':stuIDB, 'MSGID': msgID, 'DECMSG': decmsg}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "Checker"), json = mes)		
    print(response.json())


############## The new functions implemebted by me ###############
    
## Creates new hmac key and encryptio key for each message
def keyDerivationChain(KDF):
    KENC = SHA3_256.new(KDF + b'JustKeepSwimming').digest()
    KHMAC = SHA3_256.new(KDF + KENC+ b'HakunaMatata').digest()
    KKDF = SHA3_256.new(KENC + KHMAC + b'OhanaMeansFamily').digest()
    return KENC, KHMAC, KKDF

# Creates a Ks from the messages
def createKs(message):
    IDB, OTKID, MSGID, MSG, IK_X, IK_Y, EK_X, EK_Y = message
    IK_B = Point(IK_X, IK_Y, curve)
    EK_B = Point(EK_X, EK_Y, curve)

    T1 = spkA * IK_B 
    T2 = IK_PRV * EK_B 
    T3 = spkA * EK_B 
    T4 = otk_list[OTKID][0] * EK_B

    T1x, T1y = T1.x, T1.y
    T2x, T2y = T2.x, T2.y
    T3x, T3y = T3.x, T3.y
    T4x, T4y = T4.x, T4.y

    T1x_bytes, T1y_bytes = T1x.to_bytes((T1x.bit_length() + 7) // 8, byteorder='big'), T1y.to_bytes((T1y.bit_length() + 7) // 8, byteorder='big')
    T2x_bytes, T2y_bytes = T2x.to_bytes((T2x.bit_length() + 7) // 8, byteorder='big'), T2y.to_bytes((T2y.bit_length() + 7) // 8, byteorder='big')
    T3x_bytes, T3y_bytes = T3x.to_bytes((T3x.bit_length() + 7) // 8, byteorder='big'), T3y.to_bytes((T3y.bit_length() + 7) // 8, byteorder='big')
    T4x_bytes, T4y_bytes = T4x.to_bytes((T4x.bit_length() + 7) // 8, byteorder='big'), T4y.to_bytes((T4y.bit_length() + 7) // 8, byteorder='big')

    U = T1x_bytes + T1y_bytes + T2x_bytes + T2y_bytes + T3x_bytes + T3y_bytes + T4x_bytes + T4y_bytes + b'WhatsUpDoc'

    Ks = int.from_bytes(SHA3_256.new(U).digest(), "big")
    return Ks



IK_PRV, IK_PUB = KeyGen(curve)
### Sign ID with IK
id_byte = stuID.to_bytes((stuID.bit_length()+7)//8, byteorder='big')
h, s = SignGen(id_byte, curve, IK_PRV)
IKRegReq(h, s, IK_PUB.x, IK_PUB.y)
code = int(input("Enter the code: "))
IKRegVerify(code)
rcode = int(input("Enter the reset code: "))


# Register SPK
spkA, spkPub = KeyGen(curve)
x, y = spkPub.x, spkPub.y
mx, my = x.to_bytes((x.bit_length() + 7) // 8, byteorder='big'), y.to_bytes((y.bit_length() + 7) // 8, byteorder='big')
spk_m = mx + my
spk_h, spk_s = SignGen(spk_m, curve, IK_PRV)
SPKReg(spk_h, spk_s, spkPub.x, spkPub.y)

# Register OTK
T = spkA * IKey_Ser
ux, uy = T.x.to_bytes((T.x.bit_length() + 7) // 8, byteorder='big'), T.y.to_bytes((T.y.bit_length() + 7) // 8, byteorder='big')
U = b'TheHMACKeyToSuccess' + uy + ux
HMAC_key = int.from_bytes(SHA3_256.new(U).digest(), "big")
HMAC_key_bytes = HMAC_key.to_bytes((HMAC_key.bit_length() + 7) // 8, byteorder='big')

otk_list = []
for i in range(10):
    otk_k, otk_pub = KeyGen(curve)
    otk_list.append((otk_k, otk_pub))
    x, y = otk_pub.x, otk_pub.y
    mx, my = x.to_bytes((x.bit_length() + 7) // 8, byteorder='big'), y.to_bytes((y.bit_length() + 7) // 8, byteorder='big')
    otk_m = mx + my
    otk_hmac = HMAC.new(HMAC_key_bytes, otk_m, SHA256)
    otk_hmac_hex = otk_hmac.hexdigest()
    OTKReg(i, x, y, otk_hmac_hex)

### PHASE 2 ###
print()
print("+++++++++++++++++++++++++++++++++++++++++++++")
print()
print("Checking the inbox for incoming messages")
print("+++++++++++++++++++++++++++++++++++++++++++++")

print()
print("Signing my stuID with my private IK")
print()

PseudoSendMsg(h, s)

print()
print("+++++++++++++++++++++++++++++++++++++++++++++")
print()

decrypted_messages = []
for i in range(5):
    message = ReqMsg(h, s)
    IDB, OTKID, MSGID, MSG, IK_X, IK_Y, EK_X, EK_Y = message
    print()
    print("I got this from client ", IDB,": ", MSG, sep="")
    print()
    Ks = createKs(message)
    KKDF = Ks.to_bytes((Ks.bit_length() + 7) // 8, byteorder='big')

    KENC, KHMAC = None, None
    for j in range(MSGID):
        KENC, KHMAC, KKDF = keyDerivationChain(KKDF)

    message_bytes = MSG.to_bytes((MSG.bit_length() + 7) // 8, byteorder='big')
    print("Converting message to bytes to decrypt it...\n")
    print("Converted message is:", message_bytes)
    print()
    print("Generating the key Ks, Kenc, & Khmac and then the HMAC value ..\n")
    nonce = message_bytes[:8]
    ciphertext = message_bytes[8:-32]
    hmac = message_bytes[-32:] 

    val = HMAC.new(KHMAC, ciphertext, digestmod=SHA256)
    print("hmac is:", val.digest())
    print()

    if hmac == val.digest():
        print("HMAC value is verified")
        algorithm = AES.new(KENC, AES.MODE_CTR, nonce=nonce)
        plaintext = algorithm.decrypt(ciphertext).decode("utf-8")
        decrypted_messages.append((plaintext, IDB))
        Checker(stuID, IDB, MSGID, plaintext)
    else:
        print("Hmac value couldn't be verified")
        plaintext = "INVALIDHMAC"
        decrypted_messages.append((plaintext, IDB))
        Checker(stuID, IDB, MSGID, plaintext)
    print()
    print("+++++++++++++++++++++++++++++++++++++++++++++")
    print()


del_messages = ReqDelMsg(h, s)
if del_messages == None:
    del_messages = []

for i in range(1, len(decrypted_messages) + 1):
    if i in del_messages:
        print("Message", i, "- Was deleted by sender -", decrypted_messages[i-1][1])
    else:
        if decrypted_messages[i-1][0] == "INVALIDHMAC":
            continue
        else:
            print("Message", i, "-", decrypted_messages[i-1][0], "- Read")


ResetOTK(h, s)
ResetSPK(h, s)
ResetIK(rcode)