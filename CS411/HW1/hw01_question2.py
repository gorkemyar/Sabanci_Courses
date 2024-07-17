from hw01_helper import *

def character_frequency(text):
    """
    Return a dictionary of character frequencies in the given text.
    """
    freq = {}
    for char in text:
        char = str(char).lower()
        if char.isalpha():
            if char in freq:
                freq[char] += 1
            else:
                freq[char] = 1
    return freq

def find_all_possible_alphas(num):
    """Return all possible values of alpha for the given number.
    """
    alphas = {}
    for i in range(1, num):
        a = modinv(i, num)
        if a != None:
            alphas[i] = a
    return alphas

def solve_affine_cipher(ciphertext, frequent_letter):
    """Return the all possible plaintexts that corresponds to the given ciphertext.

    Parameters:
        ciphertext (str): The ciphertext to decode.
        frequent_letter (str): The most frequent letter in the plaintext.

    Returns:
    """
    freq = character_frequency(ciphertext)
    max_freq = max(freq.values())
    max_freq_letters = [key for key, value in freq.items() if value == max_freq]

    alphas = find_all_possible_alphas(26)

    res = {}
    for letter in max_freq_letters:
        for alpha, gamma in alphas.items():
            
            key.alpha = alpha
            key.gamma = gamma
            key.beta = ((ord(letter)- ord('a')) - alpha*(ord(frequent_letter)- ord('a'))) % 26
            key.theta = (26 - key.gamma*key.beta) % 26
            decipher = Affine_Dec(ciphertext, key)
            res[decipher] = [key.alpha, key.beta, key.gamma, key.theta]

    return res
# print(character_frequency("J gjg mxa czjq ayr arpa. J ulpa cxlmg ayerr ylmgerg rqrwrm hzdp ax gx ja hexmn."))
# print(len(find_all_possible_alphas(26)))
res = solve_affine_cipher("J gjg mxa czjq ayr arpa. J ulpa cxlmg ayerr ylmgerg rqrwrm hzdp ax gx ja hexmn.", "t")
for key, value in res.items():
    print(key)
    print(value)