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
    global E
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
    k = 1748178 #randint(0,n-2)
    R = k * P
    r = R.x % n
    h = int.from_bytes(SHA3_256.new(r.to_bytes((r.bit_length()+7)//8, byteorder='big')+message).digest(), byteorder='big')%n
    s = (k - sA*h) % n
    return h, s

def SignVer(message, h, s, E, QA):
    n = E.order
    P = E.generator
    V = s*P + h*QA
    v = V.x%n
    h_ = int.from_bytes(SHA3_256.new(v.to_bytes((v.bit_length()+7)//8, byteorder='big')+message).digest(), byteorder='big')%n
    if h_ == h:
        return True
    else:
        return False



def IKRegReq(h,s,x,y):
    mes = {'ID': stuID, 'H': h, 'S': s, 'IKPUB.X': x, 'IKPUB.Y': y}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "IKRegReq"), json = mes)		
    if((response.ok) == False): print(response.json())

def IKRegVerify(code):
    mes = {'ID': stuID, 'CODE': code}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "IKRegVerif"), json = mes)
    if((response.ok) == False): raise Exception(response.json())
    print(response.json())

def SPKReg(h,s,x,y):
    mes = {'ID':stuID, 'H': h, 'S': s, 'SPKPUB.X': x, 'SPKPUB.Y': y}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "SPKReg"), json = mes)
    print(response.json())

def OTKReg(keyID,x,y,hmac):
    mes = {'ID': stuID, 'KEYID': keyID, 'OTKI.X': x, 'OTKI.Y': y, 'HMACI': hmac}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "OTKReg"), json = mes)		
    print(response.json())
    if((response.ok) == False): return False
    else: return True

def ResetIK(rcode):
    mes = {'ID': stuID, 'RCODE': rcode}
    print("Sending message is: ", mes)
    response = requests.delete('{}/{}'.format(API_URL, "ResetIK"), json = mes)		
    print(response.json())
    if((response.ok) == False): return False
    else: return True

def ResetSPK(h,s):
    mes = {'ID': stuID, 'H': h, 'S': s}
    print("Sending message is: ", mes)
    response = requests.delete('{}/{}'.format(API_URL, "ResetSPK"), json = mes)		
    print(response.json())
    if((response.ok) == False): return False
    else: return True

def ResetOTK(h,s):
    mes = {'ID': stuID, 'H': h, 'S': s}
    print("Sending message is: ", mes)
    response = requests.delete('{}/{}'.format(API_URL, "ResetOTK"), json=mes)
    print(response.json())



############## The new functions of phase 2 ###############

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


############## The new functions of phase 3 ###############

#Pseudo-client will send you 5 messages to your inbox via server when you call this function
def PseudoSendMsgPH3(h,s):
    mes = {'ID': stuID, 'H': h, 'S': s}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "PseudoSendMsgPH3"), json=mes)
    print(response.json())

# Send a message to client idB
def SendMsg(idA, idB, otkID, msgid, msg, ikx, iky, ekx, eky):
    mes = {"IDA": idA, "IDB": idB, "OTKID": int(otkID), "MSGID": msgid, "MSG": msg, "IK.X": ikx, "IK.Y": iky, "EK.X": ekx, "EK.Y": eky}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "SendMSG"), json=mes)
    print(response.json())    


# Receive KeyBundle of the client stuIDB
def reqKeyBundle(stuID, stuIDB, h, s):
    key_bundle_msg = {'IDA': stuID, 'IDB':stuIDB, 'S': s, 'H': h}
    print("Requesting party B's Key Bundle ...")
    response = requests.get('{}/{}'.format(API_URL, "ReqKeyBundle"), json=key_bundle_msg)
    print(response.json()) 
    if((response.ok) == True):
        print(response.json()) 
        res = response.json()
        return res['KEYID'], res['IK.X'], res['IK.Y'], res['SPK.X'], res['SPK.Y'], res['SPK.H'], res['SPK.s'], res['OTK.X'], res['OTK.Y']
        
    else:
        return -1, 0, 0, 0, 0, 0, 0, 0, 0


#Status control. Returns #of messages and remained OTKs
def Status(stuID, h, s):
    mes = {'ID': stuID, 'H': h, 'S': s}
    print("Sending message is: ", mes)
    response = requests.get('{}/{}'.format(API_URL, "Status"), json=mes)
    print(response.json())
    if (response.ok == True):
        res = response.json()
        return res['numMSG'], res['numOTK'], res['StatusMSG']


############## The new functions of BONUS ###############

# Exchange partial keys with users 2 and 4
def ExchangePartialKeys(stuID, z1x, z1y, h, s):
    request_msg = {'ID': stuID, 'z1.x': z1x, 'z1.y': z1y, 'H': h, 'S': s}
    print("Sending your PK (z) and receiving others ...")
    response = requests.get('{}/{}'.format(API_URL, "ExchangePartialKeys"), json=request_msg)
    if ((response.ok) == True):
        print(response.json())
        res = response.json()
        return res['z2.x'], res['z2.y'], res['z4.x'], res['z4.y']
    else:
        print(response.json())
        return 0, 0, 0, 0


# Exchange partial keys with user 3
def ExchangeXs(stuID, x1x, x1y, h, s):
    request_msg = {'ID': stuID, 'x1.x': x1x, 'x1.y': x1y, 'H': h, 'S': s}
    print("Sending your x and receiving others ...")
    response = requests.get('{}/{}'.format(API_URL, "ExchangeXs"), json=request_msg)
    if ((response.ok) == True):
        print(response.json())
        res = response.json()
        return res['x2.x'], res['x2.y'], res['x3.x'], res['x3.y'], res['x4.x'], res['x4.y']
    else:
        print(response.json())
        return 0, 0, 0, 0, 0, 0

# Check if your conference key is correct
def BonusChecker(stuID, Kx, Ky):
    mes = {'ID': stuID, 'K.x': Kx, 'K.y': Ky}
    print("Sending message is: ", mes)
    response = requests.put('{}/{}'.format(API_URL, "BonusChecker"), json=mes)
    print(response.json())

############## MY FUNCTIONS ###############

# Creates a Ks from the messages
def createServerKs(message, otk_dict, spkA, IK_PRV):
    IDB, OTKID, MSGID, MSG, IK_X, IK_Y, EK_X, EK_Y = message
    IK_B = Point(IK_X, IK_Y, curve)
    EK_B = Point(EK_X, EK_Y, curve)

    T1 = spkA * IK_B 
    T2 = IK_PRV * EK_B 
    T3 = spkA * EK_B 
    T4 = otk_dict[OTKID][0] * EK_B

    T1x, T1y = T1.x, T1.y
    T2x, T2y = T2.x, T2.y
    T3x, T3y = T3.x, T3.y
    T4x, T4y = T4.x, T4.y

    T1x_bytes, T1y_bytes = T1x.to_bytes((T1x.bit_length() + 7) // 8, byteorder='big'), T1y.to_bytes((T1y.bit_length() + 7) // 8, byteorder='big')
    T2x_bytes, T2y_bytes = T2x.to_bytes((T2x.bit_length() + 7) // 8, byteorder='big'), T2y.to_bytes((T2y.bit_length() + 7) // 8, byteorder='big')
    T3x_bytes, T3y_bytes = T3x.to_bytes((T3x.bit_length() + 7) // 8, byteorder='big'), T3y.to_bytes((T3y.bit_length() + 7) // 8, byteorder='big')
    T4x_bytes, T4y_bytes = T4x.to_bytes((T4x.bit_length() + 7) // 8, byteorder='big'), T4y.to_bytes((T4y.bit_length() + 7) // 8, byteorder='big')

    U = T1x_bytes + T1y_bytes + T2x_bytes + T2y_bytes + T3x_bytes + T3y_bytes + T4x_bytes + T4y_bytes + b'WhatsUpDoc'
    return SHA3_256.new(U).digest()
    
# Creates new hmac key and encryptio key for each message
def keyDerivationChain(KDF):
    KENC = SHA3_256.new(KDF + b'JustKeepSwimming').digest()
    KHMAC = SHA3_256.new(KDF + KENC+ b'HakunaMatata').digest()
    KKDF = SHA3_256.new(KENC + KHMAC + b'OhanaMeansFamily').digest()
    return KENC, KHMAC, KKDF

# Decrypts the message
def phase3Checker(otk_dict, spkA, IK_PRV, h, s):
    print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
    print("------------------- PHASE3 CHECKER ------------------")
    print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
    message = ReqMsg(h, s)
    print("Message is:", message)
    while message != None:
        IDB, OTKID, MSGID, MSG, IK_X, IK_Y, EK_X, EK_Y = message
        print("\nI got this from client ", IDB, sep="")

        KKDF, KENC, KHMAC = createServerKs(message, otk_dict, spkA, IK_PRV), None, None
        for j in range(MSGID):
            KENC, KHMAC, KKDF = keyDerivationChain(KKDF)

        message_bytes = MSG.to_bytes((MSG.bit_length() + 7) // 8, byteorder='big')
        nonce, ciphertext, hmac = message_bytes[:8], message_bytes[8:-32], message_bytes[-32:] 
        hmac_calculated = HMAC.new(KHMAC, ciphertext, digestmod=SHA256).digest()

        if hmac == hmac_calculated:
            print("HMAC value is verified")
            algorithm = AES.new(KENC, AES.MODE_CTR, nonce=nonce)
            plaintext = algorithm.decrypt(ciphertext).decode("utf-8")
        else:
            print("Hmac value couldn't be verified")
            plaintext = "INVALIDHMAC"

        print("Plaintext is:", plaintext)
        print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
        message = ReqMsg(h, s)
    
def createKsPseudoClient(SPK_B, IK_B, OTK_B, EK_PRV, IK_PRV):
    T1 = IK_PRV * SPK_B
    T2 = EK_PRV * IK_B
    T3 = EK_PRV * SPK_B
    T4 = EK_PRV * OTK_B

    T1x, T1y = T1.x, T1.y
    T2x, T2y = T2.x, T2.y
    T3x, T3y = T3.x, T3.y
    T4x, T4y = T4.x, T4.y

    T1x_bytes, T1y_bytes = T1x.to_bytes((T1x.bit_length() + 7) // 8, byteorder='big'), T1y.to_bytes((T1y.bit_length() + 7) // 8, byteorder='big')
    T2x_bytes, T2y_bytes = T2x.to_bytes((T2x.bit_length() + 7) // 8, byteorder='big'), T2y.to_bytes((T2y.bit_length() + 7) // 8, byteorder='big')
    T3x_bytes, T3y_bytes = T3x.to_bytes((T3x.bit_length() + 7) // 8, byteorder='big'), T3y.to_bytes((T3y.bit_length() + 7) // 8, byteorder='big')
    T4x_bytes, T4y_bytes = T4x.to_bytes((T4x.bit_length() + 7) // 8, byteorder='big'), T4y.to_bytes((T4y.bit_length() + 7) // 8, byteorder='big')

    U = T1x_bytes + T1y_bytes + T2x_bytes + T2y_bytes + T3x_bytes + T3y_bytes + T4x_bytes + T4y_bytes + b'WhatsUpDoc'

    return SHA3_256.new(U).digest()
    

############## PHASE 1 MAIN ###############

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
print("------------------- PHASE1 ------------------")
print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

IKey_Ser = Point(13235124847535533099468356850397783155412919701096209585248805345836420638441, 93192522080143207888898588123297137412359674872998361245305696362578896786687, curve)
IK_PRV, IK_PUB = KeyGen(curve)

print("Here is my private Identity Key\n", IK_PRV)
print("My ID number is ", stuID)

id_byte = stuID.to_bytes((stuID.bit_length()+7)//8, byteorder='big')
print("Converted my ID to bytes in order to sign it: ", id_byte)
h, s = SignGen(id_byte, curve, IK_PRV)
print("Signature of my ID number is: \nh=", h, "\ns=", s)
print("Sending signature and my IKEY to server via IKRegReq() function in json format")

IKRegReq(h, s, IK_PUB.x, IK_PUB.y)
code = int(input("Enter verification code which is sent to you: "))
print("Sending the verification code to server via IKRegVerify() function in json format")
IKRegVerify(code)
rcode = int(input("Enter reset code which is sent to you: "))


# Register SPK
print("Generating SPK ...")
spk_a, spk_pub = KeyGen(curve)
print("Private SPK:", spk_a)
print("Public SPK.x:", spk_pub.x)
print("Public SPK.y:", spk_pub.y)
print("Convert SPK.x and SPK.y to bytes in order to sign them then concatenate them")
print("+++++++++++++++++++++++++++++++++++++++++++++")
x, y = spk_pub.x, spk_pub.y
mx, my = x.to_bytes((x.bit_length() + 7) // 8, byteorder='big'), y.to_bytes((y.bit_length() + 7) // 8, byteorder='big')
spk_m = mx + my
spk_h, spk_s = SignGen(spk_m, curve, IK_PRV)
print("Signature of SPK is: \nh= ", spk_h, "\ns= ", spk_s, sep="")
print("Sending SPK and the signatures to the server via SPKReg() function in json format...\n")
print("+++++++++++++++++++++++++++++++++++++++++++++")
SPKReg(spk_h, spk_s, spk_pub.x, spk_pub.y)

# Register OTK
print("\n++++++++++++++++++++++++++++++++++++++++++++")
print("Creating HMAC key (Diffie Hellman)")
T = spk_a * IKey_Ser
ux, uy = T.x.to_bytes((T.x.bit_length() + 7) // 8, byteorder='big'), T.y.to_bytes((T.y.bit_length() + 7) // 8, byteorder='big')
U = b'TheHMACKeyToSuccess' + uy + ux
HMAC_key = int.from_bytes(SHA3_256.new(U).digest(), "big")
HMAC_key_bytes = HMAC_key.to_bytes((HMAC_key.bit_length() + 7) // 8, byteorder='big')
print("HMAC key is created ", HMAC_key_bytes)
otk_dict = {0: None, 1: None, 2: None, 3: None, 4: None, 5: None, 6: None, 7: None, 8: None, 9: None}
for i in range(10):
    otk_k, otk_pub = KeyGen(curve)
    otk_dict[i] = (otk_k, otk_pub)
    x, y = otk_pub.x, otk_pub.y
    mx, my = x.to_bytes((x.bit_length() + 7) // 8, byteorder='big'), y.to_bytes((y.bit_length() + 7) // 8, byteorder='big')
    otk_m = mx + my
    otk_hmac = HMAC.new(HMAC_key_bytes, otk_m, SHA256)
    otk_hmac_hex = otk_hmac.hexdigest()
    OTKReg(i, x, y, otk_hmac_hex)

print("OTK keys were generated successfully!")
print("List of OTKs: ", otk_dict)

############## PHASE 2 MAIN ###############

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
print("------------------- PHASE2 ------------------")
print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

print("\nChecking the inbox for incoming messages\n+++++++++++++++++++++++++++++++++++++++++++++\n")
# Register for Messages
PseudoSendMsg(h, s)

# Decrypt the messages
decrypted_messages = []
numMSG, numOTK, StatusMSG = Status(stuID, h, s)
for i in range(numMSG):
    message = ReqMsg(h, s)
    IDB, OTKID, MSGID, MSG, IK_X, IK_Y, EK_X, EK_Y = message

    print("\nI got this from client ", IDB,": ", MSG, "\n", sep="")

    KKDF, KENC, KHMAC = createServerKs(message, otk_dict, spk_a, IK_PRV), None, None

    for j in range(MSGID):
        KENC, KHMAC, KKDF = keyDerivationChain(KKDF)

    message_bytes = MSG.to_bytes((MSG.bit_length() + 7) // 8, byteorder='big')
    print("Converting message to bytes to decrypt it...\n")
    print("Converted message is:", message_bytes)
    print("\nGenerating the key Ks, Kenc, & Khmac and then the HMAC value ..\n")
    nonce, ciphertext, hmac = message_bytes[:8], message_bytes[8:-32], message_bytes[-32:] 

    hmac_calculated = HMAC.new(KHMAC, ciphertext, digestmod=SHA256).digest()
    print("hmac is:", hmac_calculated, "\n")

    if hmac == hmac_calculated:
        print("HMAC value is verified")
        algorithm = AES.new(KENC, AES.MODE_CTR, nonce=nonce)
        plaintext = algorithm.decrypt(ciphertext).decode("utf-8")
        decrypted_messages.append((plaintext, IDB, MSGID))
        Checker(stuID, IDB, MSGID, plaintext)
    else:
        print("Hmac value couldn't be verified")
        plaintext = "INVALIDHMAC"
        decrypted_messages.append((plaintext, IDB, MSGID))
        Checker(stuID, IDB, MSGID, plaintext)
    print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

print("Checking whether there were some deleted messages!!\n==========================================")

# Print not deleted messages
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

############## PHASE 3 MAIN ###############

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
print("------------------- PHASE3 ------------------")
print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

id_byte_b = stuIDB.to_bytes((stuIDB.bit_length()+7)//8, byteorder='big')
h_b, s_b = SignGen(id_byte_b, curve, IK_PRV)

keyBundle = reqKeyBundle(stuID, stuIDB, h_b, s_b)
otk_id_B, IKx_B, IKy_B, SPKx_B, SPKy_B, SPKh_B, SPKs_B, OTKx_B, OTKy_B = keyBundle

spk_m = SPKx_B.to_bytes((SPKx_B.bit_length() + 7) // 8, byteorder='big') + SPKy_B.to_bytes((SPKy_B.bit_length() + 7) // 8, byteorder='big')
IK_B = Point(IKx_B, IKy_B, curve)

if SignVer(spk_m, SPKh_B, SPKs_B, curve, IK_B):
    print("SPK B is verified!")
    EK_PRV, EK_PUB = KeyGen(curve)
    SPK_B = Point(SPKx_B, SPKy_B, curve)
    OTK_B = Point(OTKx_B, OTKy_B, curve)

    for message in decrypted_messages:
        KKDF, KENC, KHMAC = createKsPseudoClient(SPK_B, IK_B, OTK_B, EK_PRV, IK_PRV), None, None
        if message[0] != "INVALIDHMAC":
            print("Sending message to client", message[1])
            print("U is:", KKDF)
            for i in range(message[2]):
                KENC, KHMAC, KKDF = keyDerivationChain(KKDF)

            nonce = Random.new().read(8)
            algorithm = AES.new(KENC, AES.MODE_CTR, nonce=nonce)
            ciphertext = algorithm.encrypt(message[0].encode("utf-8"))
            hmac = HMAC.new(KHMAC, ciphertext, digestmod=SHA256).digest()
            msg = nonce + ciphertext + hmac
            msg = int.from_bytes(msg, "big")
            SendMsg(stuID, stuIDB, otk_id_B, message[2], msg, IK_PUB.x, IK_PUB.y, EK_PUB.x, EK_PUB.y)

    #phase3Checker(otk_dict, spk_a, IK_PRV, h, s)
    numMSG, numOTK, StatusMSG = Status(stuID, h, s)
    print(StatusMSG)
    if numOTK < 10:
        otk_k, otk_pub = KeyGen(curve)
        otk_dict[otk_id_B] = (otk_k, otk_pub)
        x, y = otk_pub.x, otk_pub.y
        mx, my = x.to_bytes((x.bit_length() + 7) // 8, byteorder='big'), y.to_bytes((y.bit_length() + 7) // 8, byteorder='big')
        otk_m = mx + my
        otk_hmac = HMAC.new(HMAC_key_bytes, otk_m, SHA256)
        otk_hmac_hex = otk_hmac.hexdigest()
        OTKReg(otk_id_B, x, y, otk_hmac_hex)
    numMSG, numOTK, StatusMSG = Status(stuID, h, s)
    print(StatusMSG)

else:
    print("SPK B is not verified!")


############## BONUS MAIN ###############
    
print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
print("------------------- BONUS ------------------")
print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

r1, z1 = KeyGen(curve)
z1x, z1y = z1.x, z1.y
m_z = z1x.to_bytes((z1x.bit_length() + 7) // 8, byteorder='big') + z1y.to_bytes((z1y.bit_length() + 7) // 8, byteorder='big')
z1_h, z1_s = SignGen(m_z, curve, IK_PRV)

print("Generating my partial conference key")
print("Signing my pratial conference key")
print("Sending your PK (z) and receiving others ...")

z2x, z2y, z4x, z4y = ExchangePartialKeys(stuID, z1x, z1y, z1_h, z1_s)

z2 = Point(z2x, z2y, curve)
z4 = Point(z4x, z4y, curve)

X1 = r1 * (z2 - z4)
x1x, x1y = X1.x, X1.y

print("Exchanging partial keys\n")
print("calculated x1:", X1)

m_x = x1x.to_bytes((x1x.bit_length() + 7) // 8, byteorder='big') + x1y.to_bytes((x1y.bit_length() + 7) // 8, byteorder='big')
x1_h, x1_s = SignGen(m_x, curve, IK_PRV)
x2x, x2y, x3x, x3y, x4x, x4y = ExchangeXs(stuID, x1x, x1y, x1_h, x1_s)

print("exchanging X's\n")

x2 = Point(x2x, x2y, curve)
x3 = Point(x3x, x3y, curve)
x4 = Point(x4x, x4y, curve)

p1 = 4 * z4 * r1
p2 = 3 * X1
p3 = 2 * x2
p4 = x3

K = p1 + p2 + p3 + p4

print("Calculated conference key:", K)
BonusChecker(stuID, K.x, K.y)

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

numMSG, numOTK, StatusMSG = Status(stuID, h, s)
print(StatusMSG)

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

ResetOTK(h, s)
ResetSPK(h, s)
ResetIK(rcode)