from hw01_question2 import character_frequency
from hw01_helper import *

ciphertext = "FNZ FFZZMLQQZVO GAXXH PZ UPU QXGIHU UY NWJXR AHBDLPOMK YOUPZM, VOZAYCD. J TGQH B XUIJJZM ARS XOAH, BZJ D JP AT GLWUTB LO EVDWF AL GRHUI. OKPGMC L NME IRU NKGLFHK DQ UTK JUEQX JI UTK PQJHKMVF, KKO L MABZ WIQ YOLDWE GLUFRZ OFMBZV BE ZCHZ AVZQ JZ YKUJZM. D OPHK OKF NRPH TWE, D OPHK NRNQ VZRQXK, RKPY UIH MABZV ZAA FQPI YJPFFOHHT IOOKPGZ FQPIOIJ XTE. D OPHK NRNQ MMHBF JZHEE JJQF NE HHO, FNJXHT O’QH MATB FFMYZG QQXCDQE ZJ KBHK ADJFN DQ UTKH, BFF LMRN ARY KBNOO ROQ’Y CHBDZ KUJLKN WIQS. CHSQ ZCHZ TGQH CDUPJIF ZCH TAAK IPD EJX, FMZ DW, JF CDOM PU TRV SUJG. JF’Y ALSEZ-MDUQ YJXQ, FNZB LZUR KPI ZJ PBWK DW IQXZ. L XMTO WP FXVYFX OI HVDUKH, BXEJVIM, O NKBXR NHU ALA ISAS CHSQ. GIG ZQZ D NOAC OKBF O VP PZRT JPUTB WP M MMDWQEVUE, NAO LU’E G HRTF VMHDUUPV HDGQHZMXY, WIMZ’N ZIMZ DW JE. VMHDUUPV BDK OKF PKVG UTGO OJQ ZCHSQ, KQHSK YOROQ UQHS FNZP TBKVNT AL NXDT HPUOUTB OJRK DQ UTK KDTF, UA VVON KDTEOJQBFK ADJFN DQ UTKDU XAXF, WIQOM WSGZC, WIQOM VUDABJMQ GIG UTKDU TOOZQDQ, ZCDU U QIRX U YCDMX LVOM AT OKF SXJXOP GIG LUYN WIAYZ VUATZV BZJ RHFB UQHS FNZP; UTUPJI U’S XROHOIFFP OI PZ TKVUU FNVW JF’Y GROS HZHO ZUOKJZM WXU M MMDWQEVUE. MTY L TTGGO OAZ RHFB LMRN PKNSBUX, WXU EOHSMK HZFBGYZ L TTGGO CQ NVSQK OI PZ FKVUT, U YCDMX YOHFB ST VPGR DQ FYUOLPZ. O GRWQ ZCH TFOXNZ XKVYFE OI VQDOIJ, UTK WOVQ YFB - UTGO’V BXR DW JE. OO’V OAZ V PBFZZU PR OIWFXRZFU AX GRHUI, DW’T XUQLOS CDWI ATZ’V JZYDGF, IOOK PZK’N VUASVFI."

def omit_non_alphabetic_characters(text):
    res = ""
    for i in range(len(text)):
        if text[i].isalpha():
            res += text[i]
    return res

def find_shifting_counts(ciphertext, max_key_length = 20):
    res = {}
    length = len(ciphertext)
    for key_length in range(1, max_key_length + 1):
        count = 0
        for i in range(length):
            if i + key_length < length:
                if ciphertext[i] == ciphertext[i + key_length] and ciphertext[i].isalpha():
                    count += 1
        res[key_length] = count
    return res

def divide_ciphertext(ciphertext, key_length):
    divided_ciphertext = []
    for i in range(key_length):
        divided_ciphertext.append(ciphertext[i::key_length])
    return divided_ciphertext

def solve_shift_cipher(ciphertext, key):
    res = ""
    for i in range(len(ciphertext)):
        if ciphertext[i].isalpha():
            res += chr((ord(ciphertext[i]) - ord('A') + key) % 26 + ord('A'))
        else:
            res += ciphertext[i]
    return res

def find_most_frequent_letter(ciphertext):
    freq = character_frequency(ciphertext)
    max_freq = max(freq.values())
    max_freq_letters = [key for key, value in freq.items() if value == max_freq]
    return max_freq_letters[0]

def solve_vigenere_cipher(ciphertext, max_occured_letters, key_len):
    divided_ciphertext = divide_ciphertext(ciphertext, key_len)

    shift_ciphers = []
    for i in range(key_len):
        max_freq_letter = find_most_frequent_letter(divided_ciphertext[i]).upper()
        tmp = []
        for lt in max_occured_letters:
            shift = (ord(max_freq_letter) - ord(lt)) % 26
            decipher_shift = -1 * shift % 26

            txt = solve_shift_cipher(divided_ciphertext[i], decipher_shift)

            tmp.append(shift_text(txt, chr(shift + ord('A'))))
        shift_ciphers.append(tmp)
    
    res = {}

    number_of_combinations =  len(max_occured_letters)**key_len
    
    for i in range(0, number_of_combinations):
        txt = [" "]*len(ciphertext)

        vigenere_key = ""
        for j in range(key_len):
            index = (i // (len(max_occured_letters) ** j)) % len(max_occured_letters)
            tmp = shift_ciphers[j][index]
            vigenere_key += tmp.key
            
            for k in range(len(tmp.text)):
                txt[j + k * key_len] = tmp.text[k]
                
        
        res[vigenere_key] = "".join(txt)
            
    return res
        

def beatify_result(cipher, decipher):
    res = [" "]*len(cipher)
    non_alpha_count = 0
    for i in range(len(cipher)):
        if cipher[i].isalpha():
            res[i] = decipher[i - non_alpha_count]
        else:
            res[i] = cipher[i]
            non_alpha_count += 1
    return "".join(res)

class shift_text(object):
    text=""
    key=0
    def __init__(self, text, key):
        self.text = text
        self.key = key

#print(find_shifting_counts(omit_non_alphabetic_characters(ciphertext), 20))
ciphertext_c = omit_non_alphabetic_characters(ciphertext)
raw = solve_vigenere_cipher(ciphertext_c, ["E", "T", "A"], 5)

for key, value in raw.items():

    print(key, beatify_result(ciphertext, value)[:100])
    print("--------------------------------------------------")


print(beatify_result(ciphertext, raw["MGVDB"]))