from hw2_helper import *
from client import *
from myntl import *

pair = getQ1()
n = pair[0]
t = pair[1]

# Question 1a

count = 0
for i in range(1, n+1):
    if egcd(i, n)[0] == 1:
        count += 1
print("Question 1a: ", count)
checkQ1a(count)

# Question 1b
def create_generator(g, n):
    check_list = [0]*n
    for i in range(1, n):
        check_list[pow(g, i, n)] = 1
    return sum(check_list)

for i in range(2, n):
    if create_generator(i, n) == n-1:
        print("Question 1b: ", i)
        checkQ1b(i)
        break

# Question 1c
for i in range(1, n):
    if create_generator(i, n) == t:
        print("Question 1c: ", i)
        checkQ1c(i)
        break