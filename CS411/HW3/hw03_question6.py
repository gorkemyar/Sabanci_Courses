def egcd(a, b):
    x,y, u,v = 0,1, 1,0
    while a != 0:
        q, r = b//a, b%a
        m, n = x-u*q, y-v*q
        b,a, x,y, u,v = a,r, u,v, m,n
    gcd = b
    return gcd, x, y

a_1  = 2700926558
b_1  = 967358719
q_1  = 3736942861

a_2  = 1759062776
b_2  = 1106845162
q_2  = 3105999989

a_3  = 2333074535
b_3  = 2468838480
q_3  = 2681377229 


Q = q_1*q_2*q_3

Q_1 = Q // q_1
Q_2 = Q // q_2
Q_3 = Q // q_3
M_1 = egcd(Q_1, q_1)[1] % q_1
M_2 = egcd(Q_2, q_2)[1] % q_2
M_3 = egcd(Q_3, q_3)[1] % q_3


A = a_1*Q_1*M_1 + a_2*Q_2*M_2 + a_3*Q_3*M_3
B = b_1*Q_1*M_1 + b_2*Q_2*M_2 + b_3*Q_3*M_3


X = A * B
R = X % Q


print("A is",A)
print("B is", B)
print("A*B is", X)

print("r1 is", R % q_1)
print("r2 is", R % q_2)
print("r3 is", R % q_3)

assert R % q_1 == (a_1*b_1) % q_1
assert R % q_2 == (a_2*b_2) % q_2
assert R % q_3 == (a_3*b_3) % q_3