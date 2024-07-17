from hw01_helper import *

def solve_shift_cipher(ciphertext):
    """Return the all possible plaintexts that corresponds to the given ciphertext.

    Parameters:
        ciphertext (str): The ciphertext to decode.

    Returns:
        dictionary (int, str): Key is the shift value, value is the corresponding plaintext.
    """

    res = {}
    for i in range(0, 26):
        tmp = ""
        for j in range(0, len(ciphertext)):
            tmp += chr((ord(ciphertext[j]) - ord('A') + i) % 26 + ord('A'))
        res[i] = tmp
    return res

res = solve_shift_cipher("NLPDLC")
for i,v in res.items():
    print(i, v)