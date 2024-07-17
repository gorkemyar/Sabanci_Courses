import sys
sys.path.append('.')

from easy_test import *
from medium_test import *
from hard_test import *
import board as bd
import searcher as sr
import state as st
import timer as tm
import benchmarks as bm
import tracemalloc

#################### H2 ####################
h2_easy_costs = []
h2_easy_time = []
h2_easy_searched_states = []
h2_easy_space = []
h2_easy_cpu = []

h2_medium_costs = []
h2_medium_time = []
h2_medium_searched_states = []
h2_medium_space = []
h2_medium_cpu = []

h2_hard_costs = []
h2_hard_time = []
h2_hard_searched_states = []
h2_hard_space = []
h2_hard_cpu = []

#################### H1 ####################

h1_easy_costs = []
h1_easy_time = []
h1_easy_searched_states = []
h1_easy_space = []
h1_easy_cpu = []

h1_medium_costs = []
h1_medium_time = []
h1_medium_searched_states = []
h1_medium_space = []
h1_medium_cpu = []

h1_hard_costs = []
h1_hard_time = []
h1_hard_searched_states = []
h1_hard_space = []
h1_hard_cpu = []

def easy_test_benchmark():
    tests = [easy1(), easy2(), easy3(), easy4(), easy5()]
    timer = tm.Timer()
    for test in tests:
        h1_solver = sr.AStarSearcher(sr.h1)
        h2_solver = sr.AStarSearcher(sr.h2)
        init_board = bd.Board(test)
        init_state = st.State(init_board, None, None)
        
        tracemalloc.start()
        timer.start()
        solution, tested, space = h1_solver.find_solution(init_state)
        timer.end()
        current, peak = tracemalloc.get_traced_memory()
        tracemalloc.stop()

        h1_easy_costs.append(solution.cost)
        h1_easy_time.append(timer.get_diff())
        h1_easy_searched_states.append(tested)
        h1_easy_space.append(space)
        h1_easy_cpu.append(peak)
        
        tracemalloc.start()
        timer.start()
        solution, tested, space = h2_solver.find_solution(init_state)
        timer.end()
        current, peak = tracemalloc.get_traced_memory()
        tracemalloc.stop()


        h2_easy_costs.append(solution.cost)
        h2_easy_time.append(timer.get_diff())
        h2_easy_searched_states.append(tested)
        h2_easy_space.append(space)
        h2_easy_cpu.append(peak)
    
def medium_test_benchmark():
    tests = [mid1(), mid2(), mid3(), mid4(), mid5()]
    timer = tm.Timer()
    for test in tests:
        h1_solver = sr.AStarSearcher(sr.h1)
        h2_solver = sr.AStarSearcher(sr.h2)
        init_board = bd.Board(test)
        init_state = st.State(init_board, None, None)
        
        tracemalloc.start()
        timer.start()
        solution, tested, space = h1_solver.find_solution(init_state)
        timer.end()
        current, peak = tracemalloc.get_traced_memory()
        tracemalloc.stop()

        h1_medium_costs.append(solution.cost)
        h1_medium_time.append(timer.get_diff())
        h1_medium_searched_states.append(tested)
        h1_medium_space.append(space)
        h1_medium_cpu.append(peak)

        tracemalloc.start()
        timer.start()
        solution, tested, space = h2_solver.find_solution(init_state)
        timer.end()
        current, peak = tracemalloc.get_traced_memory()
        tracemalloc.stop()

        h2_medium_costs.append(solution.cost)
        h2_medium_time.append(timer.get_diff())
        h2_medium_searched_states.append(tested)
        h2_medium_space.append(space)
        h2_medium_cpu.append(peak)

def hard_test_benchmark():
    tests = [hard1(), hard2(), hard3(), hard4(), hard5()]
    timer = tm.Timer()
    for test in tests:
        h1_solver = sr.AStarSearcher(sr.h1)
        h2_solver = sr.AStarSearcher(sr.h2)
        init_board = bd.Board(test)
        init_state = st.State(init_board, None, None)
        
        tracemalloc.start()
        timer.start()
        solution, tested, space = h1_solver.find_solution(init_state)
        timer.end()
        current, peak = tracemalloc.get_traced_memory()
        tracemalloc.stop()

        h1_hard_costs.append(solution.cost)
        h1_hard_time.append(timer.get_diff())
        h1_hard_searched_states.append(tested)
        h1_hard_space.append(space)
        h1_hard_cpu.append(peak)

        tracemalloc.start()
        timer.start()
        solution, tested, space = h2_solver.find_solution(init_state)
        timer.end()
        current, peak = tracemalloc.get_traced_memory()
        tracemalloc.stop()

        h2_hard_costs.append(solution.cost)
        h2_hard_time.append(timer.get_diff())
        h2_hard_searched_states.append(tested)
        h2_hard_space.append(space)
        h2_hard_cpu.append(peak)

if __name__ == "__main__":
    easy_test_benchmark()
    
    print("H1 Easy Costs:", h1_easy_costs)
    print("H1 Easy Time:", h1_easy_time)
    print("H1 Easy Searched States:", h1_easy_searched_states)
    print("H1 Easy Space:", h1_easy_space)
    print("H1 Easy CPU:", h1_easy_cpu)

    print("H2 Easy Costs:", h2_easy_costs)
    print("H2 Easy Time:", h2_easy_time)
    print("H2 Easy Searched States:", h2_easy_searched_states)
    print("H2 Easy Space:", h2_easy_space)
    print("H2 Easy CPU:", h2_easy_cpu)

    medium_test_benchmark()

    print("H1 Medium Costs:", h1_medium_costs)
    print("H1 Medium Time:", h1_medium_time)
    print("H1 Medium Searched States:", h1_medium_searched_states)
    print("H1 Medium Space:", h1_medium_space)
    print("H1 Medium CPU:", h1_medium_cpu)

    print("H2 Medium Costs:", h2_medium_costs)
    print("H2 Medium Time:", h2_medium_time)
    print("H2 Medium Searched States:", h2_medium_searched_states)
    print("H2 Medium Space:", h2_medium_space)
    print("H2 Medium CPU:", h2_medium_cpu)

    hard_test_benchmark()

    print("H1 Hard Costs:", h1_hard_costs)
    print("H1 Hard Time:", h1_hard_time)
    print("H1 Hard Searched States:", h1_hard_searched_states)
    print("H1 Hard Space:", h1_hard_space)
    print("H1 Hard CPU:", h1_hard_cpu)

    print("H2 Hard Costs:", h2_hard_costs)
    print("H2 Hard Time:", h2_hard_time)
    print("H2 Hard Searched States:", h2_hard_searched_states)
    print("H2 Hard Space:", h2_hard_space)
    print("H2 Hard CPU:", h2_hard_cpu)
    
"""
H1 Easy Costs: [83, 134, 112, 120, 96]
H1 Easy Time: [0.005881786346435547, 0.07748007774353027, 0.01845407485961914, 0.006884098052978516, 0.006348848342895508]
H1 Easy Searched States: [15, 104, 20, 20, 18]
H1 Easy Space: [13, 39, 15, 17, 19]
H2 Easy Costs: [83, 95, 112, 90, 96]
H2 Easy Time: [0.0046117305755615234, 0.1690990924835205, 0.22219586372375488, 0.01723790168762207, 0.016499757766723633]
H2 Easy Searched States: [15, 167, 244, 45, 43]
H2 Easy Space: [13, 100, 67, 32, 23]

H1 Medium Costs: [123, 91, 121, 105, 139]
H1 Medium Time: [0.008692026138305664, 0.00814509391784668, 0.008311986923217773, 0.12026405334472656, 0.03216910362243652]
H1 Medium Searched States: [27, 26, 24, 223, 70]
H1 Medium Space: [14, 17, 15, 16, 17]
H2 Medium Costs: [74, 78, 121, 95, 105]
H2 Medium Time: [0.286998987197876, 0.2340412139892578, 0.6642632484436035, 0.46450185775756836, 2.080267906188965]
H2 Medium Searched States: [282, 216, 551, 370, 660]
H2 Medium Space: [75, 81, 62, 182, 219]


H1 Hard Costs: [117, 136, 133, 156, 145]
H1 Hard Time: [0.6339597702026367, 0.019854068756103516, 0.09542489051818848, 0.011204719543457031, 0.02209019660949707]
H1 Hard Searched States: [289, 43, 127, 31, 46]
H1 Hard Space: [234, 25, 47, 22, 27]
H2 Hard Costs: [106, 109, 105, 101, 118]
H2 Hard Time: [23.113584756851196, 1.2099120616912842, 8.680798053741455, 6.0731611251831055, 11.485414028167725]
H2 Hard Searched States: [1679, 661, 1888, 1331, 2014]
H2 Hard Space: [1199, 148, 873, 472, 553]



H1 Easy CPU: [79368, 372312, 91480, 96832, 96840]
H2 Easy CPU: [75888, 715416, 809728, 203880, 174592]

H1 Medium CPU: [110736, 112384, 104472, 531104, 227024]
H2 Medium CPU: [935608, 774432, 1614416, 1418928, 2257568]

H1 Hard CPU: [1366976, 178048, 450040, 138656, 188656]
H2 Hard CPU: [7416440, 2094888, 7137576, 4701688, 6454184]
"""