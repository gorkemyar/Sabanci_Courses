import random as rand
from ConSet import *

#### Sequential Testing
def test1():
    keys = ["a", "b", "c", "d"]
    cs = ConSet()

    iteration = rand.randint(5, 10)
    for i in range(iteration):
        newKey = keys[rand.randint(0, len(keys) - 1)]
        cs.insert(newKey)
        print("Inserted", newKey)
        cs.printSet()
    
    for i in range(cs.items.__len__()):
        deletedKey = cs.pop()
        print("Deleted", deletedKey)
        cs.printSet()
    
    print("Test1 passed")

def test2():
    keys = ["a", "b", "c", "d"]
    cs = ConSet()

    iteration = rand.randint(5, 10)
    for i in range(iteration):
        newKey = keys[rand.randint(0, len(keys) - 1)]
        cs.insert(newKey)
        print("Inserted", newKey)
        cs.printSet()
    
    for i in range(cs.items.__len__()):
        deletedKey = cs.pop()
        print("Deleted", deletedKey)
        cs.printSet()

    iteration = rand.randint(5, 10)
    for i in range(iteration):
        newKey = keys[rand.randint(0, len(keys) - 1)]
        cs.insert(newKey)
        print("Inserted", newKey)
        cs.printSet()

    print("Test2 passed")

def test3():

    cs = ConSet()
    deletedKey = cs.pop()
    print("Deleted", deletedKey)
    cs.printSet()
    
    print("Test3 is Failed")


def test4():
    keys = ["a", "b", "c", "d"]
    cs = ConSet()

    iteration = rand.randint(5, 10)
    for i in range(iteration):
        newKey = keys[rand.randint(0, len(keys) - 1)]
        cs.insert(newKey)
        print("Inserted", newKey)
        cs.printSet()
    
    for i in range(cs.items.__len__() + 1):
        deletedKey = cs.pop()
        print("Deleted", deletedKey)
        cs.printSet()
    
    print("Test4 is Failed")

for i in range(1):
    test1()

for i in range(1):
    test2()

test3()

test4()
