from RSA_Oracle_client import *

c, N, e = RSA_Oracle_Get()

print("c:", c)
print("N:", N)
print("e:", e)

num = 65536
numInv = modinv(num,N)

num_c = pow(num,e,N)

combined = num_c * c % N

decipher = RSA_Oracle_Query(combined)
decipher = decipher * numInv % N
message = decipher.to_bytes((decipher.bit_length()+7)//8, byteorder='big').decode('utf-8')

print("Number:", decipher)
print("Message:", message)

RSA_Oracle_Checker(message)
