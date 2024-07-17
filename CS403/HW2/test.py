from FindCyclicReferences import *

if __name__ == '__main__':
    for i in range(100):
        mr = FindCyclicReferences(5)
        mr.start("Cit-HepPh.txt")
        print("Find Cyclic References called")
        #print(mr.result)