from lfsr import *
import random

# The maximum size of the period is 2^L-1 and it is affected by the initial state of L
# Therefore I will try all possible initial states and find the maximum period
# I will use the function FindPeriod from lfsr.py

p1x = "x7 + x5 + x3 + x + 1"
p2x = "x6 + x5 + x2 + 1"
p3x = "x5 + x4 + x3 + x + 1"

p1 = [1,0,1,0,1,0,1,1]
p1.reverse()
p2 = [1,1,0,0,1,0,1]
p2.reverse()
p3 = [1,1,1,0,1,1]
p3.reverse()


def find_period_of_polynom(L, C):
    length = pow(2, L+1)
    S = [0]*L
    max_period = 0
    max_period_initial_state = [0]*L
    for i in range(length//2):
        k = bin(i)[2:]
        for j in range(len(k)):
            S[j] = int(k[j])
    

        keystream = [0]*length
        for i in range(0,length):
            keystream[i] = LFSR(C, S)
        
        period = FindPeriod(keystream)
        if period > max_period:
            max_period = period
            max_period_initial_state = S.copy()
    
    
    keystream = [0]*length
    for i in range(0,length):
        keystream[i] = LFSR(C, max_period_initial_state)
    
    print ("Max period: ", max_period)
    print ("Max period initial state: ", max_period_initial_state)
    print ("L and C(x): ", BM(keystream))
    
    

print("P1 period is")
find_period_of_polynom(7,p1)
print("P2 period is")
find_period_of_polynom(6,p2)
print("P3 period is")
find_period_of_polynom(5,p3)