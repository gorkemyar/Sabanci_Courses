import threading

N = 9244432371785620259
C = 655985469758642450
e = 2**16+1

print(N.bit_length())
print(C.bit_length())


rt = int(N ** (1/2))

p = -1
q = -1

# ending with 3
for i in range(3, rt+1, 10):
    if p != -1:
        break
    if N % i == 0:
        p = i
        q = N // i
        break
# ending with 7
for i in range(7, rt+1, 10):
    if p != -1:
        break
    if N % i == 0:
        p = i
        q = N // i
        break
# ending with 9
for i in range(9, rt+1, 10):
    if p != -1:
        break
    if N % i == 0:
        p = i
        q = N // i
        break
# ending with 1
for i in range(11, rt+1, 10):
    if p != -1:
        break
    if N % i == 0:
        print("Found it")
        p = i
        q = N // i
        break
    

print("p is", p)
print("q is", q)

# After running the above code, we get:

# p = 2485770689
# q = 3718940131

assert p * q == N

phi = (p-1) * (q-1)

def egcd(a, b):
    x,y, u,v = 0,1, 1,0
    while a != 0:
        q, r = b//a, b%a
        m, n = x-u*q, y-v*q
        b,a, x,y, u,v = a,r, u,v, m,n
    gcd = b
    return gcd, x, y

gcd, x, y = egcd(e, phi)

d = x % phi
print("d = {}".format(d))

m = pow(C, d, N)

ans = m.to_bytes((m.bit_length() + 9) // 8, byteorder='big')
ans = ans.decode('utf-8')
print("Q4: " + ans)