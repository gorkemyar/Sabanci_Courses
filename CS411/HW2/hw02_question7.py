from myntl import *
from hw2_helper import *
from lfsr import *

ctext = [0, 0, 1, 0, 0, 0, 1, 1, 0,0,1,1,1,1,0,1,1,0,1,0,0,1,0,1,1,0,0,1,0,1,1,1,0,0,1,0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1,0,1,1,1,0,1,0,1,0,0,0,0,0,1,0,0,0,1,1,1,1,1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1,0,0,1,1,1,0,1,0,1,1,1,1,0,1,0,1,0,1,0,1,0,1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1,1,1,0,1,1,0,1,0,0,1,1,1,1,0,1,0,1,0,0,1,0,1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1,1,0,0,1,0,0,1,1,0,0,0,1,1,1,0,1,0,1,1,1,0,0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1,0,1,1,1,0,1,0,1,0,0,0,1,0,1,0,1,1,0,0,0,1,0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1,0,1,1,0,1,1,0,1,0,1,1,1,0,0,0,0,0,0,0,1,1,0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1,1,0,1,0,1,1,1,1,0,0,0,0,0,1,0,1,1,0,1,0,0,1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0,0,0,0,1,1,1,0,0,1,0,1,0,1,0,1,0,0,0,0,1,1,0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1,1,0,0,1,1,0,0,0,1,0,1,0,0,1,1,1,0,1,0,0,0,0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1,0,0,0,1,1,0,0,0,0,1,0,1,1,0,0,1,0,0,0,0,1,1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1,1,0,1,0,1,1,1,1,0,0,0,1,0,1,0,1,1,0,1,1,1,1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0,0,1,1,0,1,1,1,0,1,1,0,0,1,1,1,0,1,0,1,0,1,0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1,1,0,1,0,1,0,1,1,1,1,0,0,1,0,1,0,1,0,1,1,0,0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1,0,1,0,1,0,0,0,0,1,0,1,0,0,0,1,1,1,0,0,1,1,0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0,0,1,0,1,1,0,0,1,1,1,0,1,0,1,1,0,0,0,0,0,1,0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0,1,0,1,1,1,0,1,1,0,0,0,0,0,1,0,0,0,1,1,0,0,1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1,1,1,0,1,0,1,1,1,0,1,0,1,0,0,1,1,1,0,1,1,1,1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1,0,0,0,1,0,1,0,0,1,1,1,0,1,1,0,0,0,1,1,0,0,0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1]
known_plaintext = "Erkay Savas"
encoded_plaintext = ASCII2bin(known_plaintext)

reverse_encoded_plaintext = list(reversed(encoded_plaintext))
reverse_ctext = list(reversed(ctext))

ctext_beg = reverse_ctext[:len(reverse_encoded_plaintext)]

keystream = [0]*len(reverse_encoded_plaintext)
for i in range(0,len(reverse_encoded_plaintext)):
    keystream[i] = ctext_beg[i] ^ reverse_encoded_plaintext[i]

L, Cx = BM(keystream)
print("L: ", L)
print("Cx: ", Cx)
if L < len(keystream) / 2:
    S = list(reversed(keystream[:L])) # S is the initial state of the LFSR that generates keystream
                                      # S[L-1] is the first bit of the keystream
                                      # S[0] is the last bit of the keystream
                                      # This ensures that first L bit is matching
    key = [0]*len(reverse_ctext)
    for i in range(0,len(reverse_ctext)):
        key[i] = LFSR(Cx, S)
    

    res = [0]*len(ctext)
    for i in range(0,len(reverse_ctext)):
        res[i] = key[i] ^ reverse_ctext[i]
    res = list(reversed(res))

    print(bin2ASCII(res))

