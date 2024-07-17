from ConSet import ConSet
import random as rand
import threading

n = 4
barrier = threading.Barrier(n)
lock = threading.Semaphore(1)
conset_list = [ConSet() for i in range(n)]

def nodeWork(id, n):
    executionNotCompleted = True
    round = 1
    while executionNotCompleted:
        val = rand.randint(0, n**2)

        lock.acquire()
        print("Node ", id, " proposes value ", val, " for round ", round, ".", sep="")
        lock.release() 

        for i in range(n):
            conset_list[i].insert((id, val))
        
        max_pair = (-1, -1)
        dup = False

        for i in range(n):
            pair = conset_list[id].pop()
            if pair[1] > max_pair[1]:
                max_pair = pair
                dup = False
            else:
                if pair[1] == max_pair[1]:
                    dup = True
            
        if dup:
            lock.acquire()
            print("Node ", id, " could not decide on the leader and moves to round ", round+1, ".", sep="")
            lock.release()
            round += 1
            barrier.wait()
        else:
            executionNotCompleted = False
            lock.acquire()
            print("Node ", id, " decided ", max_pair[0], " as the leader.", sep="")
            lock.release() 
            