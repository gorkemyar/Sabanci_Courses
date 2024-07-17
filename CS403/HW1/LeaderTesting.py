import threading
from Leader import *

def test1():
    threads = [threading.Thread(target=nodeWork, args=(i, n)) for i in range(n)]
    for t in threads:
        t.start()

    for t in threads:
        t.join()

for i in range(10000):
    test1()
    print("Test1 passed")