import board as bd
import searcher as sr
import state as st
import timer as tm
from additional_test import *
from hard_test import *
from easy_test import *
from medium_test import *
import tracemalloc

if __name__ == "__main__":
    print("This is the main file.")
    easy1 = mid2()
    print(easy1)
    init_board = bd.Board(easy1)
    init_state = st.State(init_board, None, None)
    #solver = sr.BFSearcher(depth_limit=len(easy1)**2 * 4)
    #solver = sr.DFSearcher(depth_limit=len(easy1)**2 * 4)
    solver = sr.AStarSearcher(sr.h2)
    timer = tm.Timer()
    tracemalloc.start()
    timer.start()
    solution, tested, space = solver.find_solution(init_state)
    timer.end()
    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()
    print(timer)
    solution.print_moves()
    print("Tested:", tested)
    print("Peak:", peak)
    print("Space:", space)
