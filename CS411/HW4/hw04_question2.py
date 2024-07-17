from RSA_OAEP import *

c = 15563317436145196345966012870951355467518223110264667537181074973436065350566
e = 65537
N = 73420032891236901695050447655500861343824713605141822866885089621205131680183

"""
four decimal digits is not too big for brute force attack. 
Also, the randomness for each number is not too big (2^8).
We can conduct a brute force attack by trying all possible combinations of the four digits with 
all possible randomness.
We can encrypt the four digits with all possible randomness and compare the result with the given c.
If the result matches, than we find the four digits.
"""

for i in range(1000, 10000):
    for j in range(2**7, 2**8):
        R = j
        c_ = RSA_OAEP_Enc(i, e, N, R)
        if c_ == c:
            print("The four digits are:", i)
            print("The random number is:", j)
            break

# The four digits are: 1308