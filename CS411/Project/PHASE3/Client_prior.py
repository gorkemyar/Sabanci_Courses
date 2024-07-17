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
stuIDB = 27970
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

############## PHASE 1 Additional Functions ###############

# Creates SPK and Register it in the server
def createRegisterSPK(IK_PRV, curve):
    print("Generating SPK ...")
    spkA, spkPub = KeyGen(curve)
    print("Private SPK:", spkA)
    print("Public SPK.x:", spkPub.x)
    print("Public SPK.y:", spkPub.y)
    print("Convert SPK.x and SPK.y to bytes in order to sign them then concatenate them")
    print("+++++++++++++++++++++++++++++++++++++++++++++")
    x, y = spkPub.x, spkPub.y
    mx, my = x.to_bytes((x.bit_length() + 7) // 8, byteorder='big'), y.to_bytes((y.bit_length() + 7) // 8, byteorder='big')
    spk_m = mx + my
    spk_h, spk_s = SignGen(spk_m, curve, IK_PRV)
    print("Signature of SPK is: \nh= ", spk_h, "\ns= ", spk_s, sep="")
    print("Sending SPK and the signatures to the server via SPKReg() function in json format...\n")
    print("+++++++++++++++++++++++++++++++++++++++++++++")
    SPKReg(spk_h, spk_s, spkPub.x, spkPub.y)
    return spkA, spkPub

# Creates OTK and Register it in the server
def createRegisterOTK(IKey_Ser, spkA, curve):
    print("\n++++++++++++++++++++++++++++++++++++++++++++")
    print("Creating HMAC key (Diffie Hellman)")
    T = spkA * IKey_Ser
    ux, uy = T.x.to_bytes((T.x.bit_length() + 7) // 8, byteorder='big'), T.y.to_bytes((T.y.bit_length() + 7) // 8, byteorder='big')
    U = b'TheHMACKeyToSuccess' + uy + ux
    HMAC_key = int.from_bytes(SHA3_256.new(U).digest(), "big")
    HMAC_key_bytes = HMAC_key.to_bytes((HMAC_key.bit_length() + 7) // 8, byteorder='big')
    print("HMAC key is created ", HMAC_key_bytes)
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
    
    print("OTK keys were generated successfully!")
    print("List of OTKs: ", otk_list)
    return otk_list, HMAC_key

############## PHASE 2 Additional Functions ###############

# Creates a Ks from the messages
def createServerKs(message, otk_list, spkA, IK_PRV):
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

# Creates new hmac key and encryptio key for each message
def keyDerivationChain(KDF):
    KENC = SHA3_256.new(KDF + b'JustKeepSwimming').digest()
    KHMAC = SHA3_256.new(KDF + KENC+ b'HakunaMatata').digest()
    KKDF = SHA3_256.new(KENC + KHMAC + b'OhanaMeansFamily').digest()
    return KENC, KHMAC, KKDF

# Decrypts the message
def decryptMessages(otk_list, spkA, IK_PRV):
    decrypted_messages = []
    for i in range(5):
        message = ReqMsg(h, s)
        IDB, OTKID, MSGID, MSG, IK_X, IK_Y, EK_X, EK_Y = message
        print()
        print("I got this from client ", IDB,": ", MSG, sep="")
        print()
        Ks = createServerKs(message, otk_list, spkA, IK_PRV)
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
            decrypted_messages.append((plaintext, IDB, MSGID))
            Checker(stuID, IDB, MSGID, plaintext)
        else:
            print("Hmac value couldn't be verified")
            plaintext = "INVALIDHMAC"
            decrypted_messages.append((plaintext, IDB, MSGID))
            Checker(stuID, IDB, MSGID, plaintext)
        print()
        print("+++++++++++++++++++++++++++++++++++++++++++++")
        print()
    return decrypted_messages

# print not deleted messages
def printMessages(decrypted_messages):
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
    return del_messages

############## PHASE 3 Additional Functions ###############

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

    Ks = int.from_bytes(SHA3_256.new(U).digest(), "big")
    return Ks

############## PHASE 1 MAIN ###############

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
print("------------------- PHASE1 ------------------")
print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

IKey_Ser = Point(13235124847535533099468356850397783155412919701096209585248805345836420638441, 93192522080143207888898588123297137412359674872998361245305696362578896786687, curve)
#IK_PRV, IK_PUB = KeyGen(curve)
IK_PRV = 59491528128188058169873226436489349319915428624811695231338495016351825059042
IK_PUB = Point(0xc857c97586e15351b34f957735f6c84988ee13a89f7a674fb740df6dff7137dc, 0x643d4a0d58689fa3b46472ec372e6f3d0739cb9437f97dcbd16efd7b749e5e7b, curve)

print("Here is my private Identity Key\n", IK_PRV)
print("My ID number is ", stuID)

id_byte = stuID.to_bytes((stuID.bit_length()+7)//8, byteorder='big')
print("Converted my ID to bytes in order to sign it: ", id_byte)
h, s = SignGen(id_byte, curve, IK_PRV)
print("Signature of my ID number is: \nh=", h, "\ns=", s)
print("Sending signature and my IKEY to server via IKRegReq() function in json format")

#IKRegReq(h, s, IK_PUB.x, IK_PUB.y)
#code = int(input("Enter verification code which is sent to you: "))
print("Sending the verification code to server via IKRegVerify() function in json format")
#IKRegVerify(code)
#rcode = int(input("Enter reset code which is sent to you: "))

rcode = 578169

# Register SPK
spk_a, spk_pub = createRegisterSPK(IK_PRV, curve)

# Register OTK
my_otk_list, my_otk_HMAC_key = createRegisterOTK(IKey_Ser, spk_a, curve)

############## PHASE 2 MAIN ###############

print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")
print("------------------- PHASE2 ------------------")
print("\n+++++++++++++++++++++++++++++++++++++++++++++\n")

print("\nChecking the inbox for incoming messages\n+++++++++++++++++++++++++++++++++++++++++++++\n")
# Register for Messages
PseudoSendMsg(h, s)
# Get and Decrypt Messages
decrypted_messages = decryptMessages(my_otk_list, spk_a, IK_PRV)

print("Checking whether there were some deleted messages!!\n==========================================")
# Print not deleted messages
del_messages = printMessages(decrypted_messages)

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

    ks_pseudo_client = createKsPseudoClient(SPK_B, IK_B, OTK_B, EK_PRV, IK_PRV)
    for message in decrypted_messages:
        if message[0] != "INVALIDHMAC":
            print("Sending message to client", message[1])
            ks_pseudo_client_bytes = ks_pseudo_client.to_bytes((ks_pseudo_client.bit_length() + 7) // 8, byteorder='big')
            print("U is:", ks_pseudo_client_bytes)
            for i in range(message[2]):
                KENC, KHMAC, ks_pseudo_client_bytes = keyDerivationChain(ks_pseudo_client_bytes)

            nonce = Random.new().read(8)
            algorithm = AES.new(KENC, AES.MODE_CTR, nonce=nonce)
            ciphertext = algorithm.encrypt(message[0].encode("utf-8"))
            hmac = HMAC.new(KHMAC, ciphertext, digestmod=SHA256).digest()
            msg = nonce + ciphertext + hmac
            msg = int.from_bytes(msg, "big")
            SendMsg(stuID, stuIDB, otk_id_B, message[2], msg, IK_PUB.x, IK_PUB.y, EK_PUB.x, EK_PUB.y)

    decrypted_messages = decryptMessages(my_otk_list, spk_a, IK_PRV)
    del_messages = printMessages(decrypted_messages)
else:
    print("SPK B is not verified!")


ResetOTK(h, s)
ResetSPK(h, s)

#ResetIK(rcode)