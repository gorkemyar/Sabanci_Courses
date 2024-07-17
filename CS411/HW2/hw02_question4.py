from hw2_helper import *
from myntl import *

# we have gcd function in hw2_helper
# I will use it instead of writing it again
# we first check gcd of n and a
# if it is 1, 
    # then we will find the inverse of a mod n
    # we will multiply b with the inverse of a mod n
    # then we will take mod n of the result
    # we will print the result
# else
    # we will divide n,a,b with gcd of n and a
    # if b is not divisible by gcd of n and a
        # we will print "No solution"
    # else
        # let's say the new n is n1, new a is a1, new b is b1
        # we will find the inverse of a1 mod n1
        # we will multiply b1 with the inverse of a1 mod n1
        # then we will take mod n1 of the result
        # there would be gcd(n, a) solutions
        


def find_solutions(n,a,b):
    gcd_n_a = gcd(a, n)
    if gcd_n_a == 1:
        inverse_a = egcd(a, n)[1] % n
        res = (b*inverse_a) % n
        print("The solution is: ")
        print(res)
    else:
        if b % gcd_n_a != 0:
            print("There are no Solutions!")
        else:
            n1 = n // gcd_n_a
            a1 = a // gcd_n_a
            b1 = b // gcd_n_a
            inverse_a1 = egcd(a1,n1)[1] % n1
            sols = (b1*inverse_a1) % n1
            print("The solutions are: ")
            for i in range(gcd_n_a):
                sol = sols + i*n1
                print(sol, " ")


# Question 4a
n = 2163549842134198432168413248765413213216846313201654681321666
a = 790561357610948121359486508174511392048190453149805781203471
b = 789213546531316846789795646513847987986321321489798756453122
print("###################### Question 4A ######################")
find_solutions(n,a,b)

# Question 4b
n = 3213658549865135168979651321658479846132113478463213516854666
a = 789651315469879651321564984635213654984153213216584984653138
b = 798796513213549846121654984652134168796513216854984321354987

print("###################### Question 4B ######################")
find_solutions(n,a,b)

# Question 4c
n = 5465132165884684652134189498513211231584651321849654897498222
a = 654652132165498465231321654946513216854984652132165849651312
b = 987965132135498749652131684984653216587986515149879613516844

print("###################### Question 4C ######################")
find_solutions(n,a,b)

# Question 4d
n = 6285867509106222295001894542787657383846562979010156750642244
a = 798442746309714903987853299207137826650460450190001016593820
b = 263077027284763417836483408268884721142505761791336585685868

print("###################### Question 4D ######################")
find_solutions(n,a,b)