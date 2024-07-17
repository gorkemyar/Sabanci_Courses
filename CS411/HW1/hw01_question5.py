from hw01_helper import *

alphabet = {'A':0, 'B':1, 'C':2, 'D':3, 'E':4, 'F':5, 'G':6, 'H':7, 'I':8, 'J':9, 'K':10, 'L':11, 'M':12, 'N':13,
'O':14, 'P':15, 'Q':16, 'R':17, 'S':18, 'T':19, 'U':20, 'V':21, 'W':22, 'X':23, 'Y':24, 'Z':25,
'.':26, ' ':27, ',':28, '!':29}
inv_alphabet = {v:k for k,v in alphabet.items()}

ciphertext = "ZHOFC.BNZCLRZ WNJ.XGI.WMBDV.MEJ!GGYKGDZ ERGMWNJ.KDGD RSW"

# modulus is 30*30 = 900 since there are 900 different bigrams
mod = 900

def encode_bigram(bigram):
    return alphabet[bigram[0]] * 30 + alphabet[bigram[1]]

def decode_bigram(bigram):
    return inv_alphabet[bigram // 30] + inv_alphabet[bigram % 30]

def find_all_possible_alphas(num):
    alphas = {}
    for i in range(1, num):
        a = modinv(i, num)
        if a != None:
            alphas[i] = a
    return alphas

def hint_helper(plaintext_bigram, ciphertext_bigram):
    pbe = encode_bigram(plaintext_bigram)
    cbe = encode_bigram(ciphertext_bigram)

    res = []
    all_alphas = find_all_possible_alphas(mod)
    for alpha in all_alphas:
        beta = (cbe - alpha * pbe) % mod
        res.append([alpha, beta])

    return res

def decipher_bigram(ciphertext, most_common_bigrams):    
    keys = hint_helper(".X", "SW")
    res = {}
    for key in keys:
        alpha = key[0]
        beta = key[1]
        gama = modinv(alpha, mod)
        theta = (mod - gama * beta) % mod
        tmp = ""
        for i in range(0, len(ciphertext), 2):
            bigram = ciphertext[i:i+2]
            pbe = encode_bigram(bigram)
            cbe = (gama * pbe + theta) % mod
            tmp += decode_bigram(cbe)
        res[tmp] = [alpha, beta, gama, theta]
    return res

res = decipher_bigram(ciphertext, ["TH", "HE", "IN"])
for txt, keys in res.items():
    print(txt, keys)
    print("-----------------")

# The answer with the key
print(res["SING, GODDESS, OF THE ANGER OF ACHILLES, SON OF PELEUS.X"])