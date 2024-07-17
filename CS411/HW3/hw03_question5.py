from client import *

ax, bx = get_poly()
#ax,bx = "01000000", "11101100"

# ax = x^6
# bx = x^7 + x^6 + x^5 + x^3 + x^2

px = "111000011"

def create_multiply(ax, bx):

    reversed_ax = ax[::-1]
    mul = []
    for i,x in enumerate(reversed_ax):
        if x == "1":
            bx_new = bx + "0"*i
            mul.append(list(bx_new))
    return mul

def sum_multiply(mul):
    max_len = max([len(x) for x in mul])
    res = []
    for i in range(1, max_len+1):
        ith = 0
        for x in mul:
            if len(x) >= i:
                ith = ith ^ int(x[-i])
        res.insert(0,str(ith))
    return res
    
def reduce_polynomial(ax, bx, px):
    px_reduce = px[1:]
    mul = create_multiply(ax, bx)
    if len(mul) == 0:
        return "0"*len(bx)
    sum_mul = sum_multiply(mul)
    while len(sum_mul) >= len(px):
        sum_mul_valid = sum_mul[-len(px) + 1:]
        sum_mul_remain = sum_mul[:-len(px) + 1]
        mul_new_list = [sum_mul_valid]
        for i, x in enumerate(sum_mul_remain):
            if x == "1":
                dummy_poly = "1"
                dummy_poly += "0"* (len(sum_mul_remain) - i -1)
                new_mul = create_multiply(dummy_poly, px_reduce)
                mul_new_list += new_mul
        sum_mul = sum_multiply(mul_new_list)
        
    return "".join(sum_mul)

res = reduce_polynomial(ax, bx, px)
print("Multiplication","".join(res))
check_mult("".join(res))

# there are two ways to do this
# 1. multiply ax with every possible polynomial and check if the result is 00000001 in mod px

# for i in range(256):
#     cx = bin(i)[2:]
#     res = reduce_polynomial(ax, cx, px)
#     if "".join(res) == "00000001":
#         print("Inverse = {}".format(cx))
#         check_inv(cx)
#         break
# cx = 10111100

# Some euclidian algorithm that I found in the internet.

def gf_degree(a) :
  res = 0
  a >>= 1
  while (a != 0) :
    a >>= 1;
    res += 1;
  return res

def gf_invert(a, mod=0x1B) :
  v = mod
  g1 = 1
  g2 = 0
  j = gf_degree(a) - 8

  while (a != 1) :
    if (j < 0) :
      a, v = v, a
      g1, g2 = g2, g1
      j = -j

    a ^= v << j
    g1 ^= g2 << j

    a %= 256  # Emulating 8-bit overflow
    g1 %= 256 # Emulating 8-bit overflow

    j = gf_degree(a) - gf_degree(v)

  return g1


inv =bin(gf_invert(64, 0xC3))[2:] 
check_inv(inv)

# 3. use the extended euclidean algorithm to find the inverse of ax in mod px


# def poly_sum(ax, bx, length):
#     cx = []
#     for i in range(length):
#         cx.append(str(int(ax[i]) ^ int(bx[i])))
#     return "".join(cx)

# def poly_divide(a, b, px, field):
#     first_a_1 = field - (a.find("1")) - 1
#     first_b_1 = field - (b.find("1")) - 1
#     #print("Last time", a, b)

#     if first_b_1 == -1:
#         raise ValueError("b cannot be zero")
#     if first_a_1 < first_b_1:
#         # print("Does not divide")
#         # print (a, b)
#         return "0"*field, a
    
#     poly = "1"
#     poly += "0" * (first_a_1 - first_b_1)

#     if len(poly) < field:
#         poly = "0" * (field - len(poly)) + poly
    
#     red_poly = reduce_polynomial(b, poly, px)

#     rmn = poly_sum(a, red_poly, field)
    
#     return poly, rmn

        

# print("poly", poly_divide("00001011", "00000011", px, 8))


# def poly_egcd(a, b, px, field):
#     zero = "0" * field
#     one = "0"*(field-1) + "1"
    
#     u, v = one, zero
#     x, y = zero, one

#     while a != zero:
#         q, r = poly_divide(b, a, px, field)
        
#         #breakpoint()
#         m, n = poly_sum(x, reduce_polynomial(u, q, px), field), poly_sum(y, reduce_polynomial(v, q, px), field)
#         b, a = a, r
#         x, y = u, v
#         u, v = m, n

#     return b, x, y

# print("Deneme",(poly_egcd(ax, px[1:], px, 8)))

# print("reduce bx", reduce_polynomial(bx, "11111000", px))