import sys
from FindCitations import *
from FindCyclicReferences import *
if __name__ == '__main__':
    # get parameters from command line
    try:
        if len(sys.argv) != 4:
            print("Invalid number of arguments")
            exit(1)
        
        fun = sys.argv[1]
        count = int(sys.argv[2])
        filename = sys.argv[3]
        if fun == "COUNT":
            citation = FindCitations(count)
            
            citation.start(filename)
        elif fun == "CYCLE":
            cycle = FindCyclicReferences(count)
            cycle.start(filename)
        else:
            print("Invalid name for function")
            exit(1)

    except Exception as e:
        print("Error")
        print(e)
        exit(1)
