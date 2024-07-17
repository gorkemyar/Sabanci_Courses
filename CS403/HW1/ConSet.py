# Fill the class given below for the first part of the assignment
# You can add new functions if necessary
# but don't change the signatures of the ones included
import threading

class ConSet:
    def __init__(self):
        self.items = {}
        self.mutex = threading.Semaphore(1)
        self.cond = threading.Semaphore(0)

    def insert(self, newItem):
        self.mutex.acquire()
        if (newItem not in self.items) or self.items[newItem] == False:
            self.items[newItem] = True
            self.cond.release()
        self.mutex.release()
    def pop(self):
        self.cond.acquire()
        self.mutex.acquire()
        res = None
        for item in self.items:
            if self.items[item] == True:
                self.items[item] = False
                res = item
                break
        self.mutex.release()
        return res
    def printSet(self):
        self.mutex.acquire()
        print("Cons Dict is", self.items)
        self.mutex.release()