import random
from state import *
import sys

# include the current directory in the path so that we can find board.py
sys.path.append('.')

class Searcher:
    def __init__(self, depth_limit=-1):
        self.states = []
        self.num_tested = 0 # number of states tested
        self.depth_limit = depth_limit

    def add_state(self, new_state):
        self.states.append(new_state)
        
    def add_states(self, new_states):        
        for state in new_states:
            if state.num_moves < self.depth_limit or self.depth_limit == -1:
                self.add_state(state)
        
    def next_state(self):
        s = random.choice(self.states)
        self.states.remove(s)
        return s    
    
    def find_solution(self, init_state):
        self.add_state(init_state)
        while self.states != []:
            s = self.next_state()
            self.num_tested += 1
            #print("Number of states tested: ", self.num_tested)
            #print("Length of states: ", len(self.states))
            #print(s.board)
            if s.is_goal():
                return s, self.num_tested, len(self.states)
            
            succ = s.successors()
            self.add_states(succ)
            
        return None, None, None
        
    
    def __repr__(self):
        s = type(self).__name__ + ': '
        s += str(len(self.states)) + ' untested, '
        s += str(self.num_tested) + ' tested, '
        return s

class BFSearcher(Searcher):
    def next_state(self):
        s = self.states[0]
        self.states = self.states[1:]
        return s

class DFSearcher(Searcher):
    def next_state(self):
        s = self.states[-1]
        self.states = self.states[:-1]
        return s
    
def h0(state):
    """ a heuristic function that always returns 0 """
    return 0

def h1(state):
    return state.board.uncolored_cells() * (state.board.border_cells() / max(len(state.board.board), len(state.board.board[0])))

def h2(state):
    return state.board.uncolored_cells()

def h3(state):
    b = state.board
    row = 0
    for r in range(len(b.board)):
        for c in range(len(b.board[0])):
            if b.board[r][c] == 0:
                row += 1
                break
    col = 0
    for c in range(len(b.board[0])):
        for r in range(len(b.board)):
            if b.board[r][c] == 0:
                col += 1
                break
    return min(row, col)
                

class AStarSearcher(Searcher):
    def __init__(self, heuristic):
        super().__init__(-1)
        self.heuristic = heuristic
    
    def add_state(self, state):
        hc = self.astar(state)
        self.states.append([hc, state])
        
    def next_state(self):
        s = min(self.states)
        self.states.remove(s)
        return s

    def astar(self, state):
        return self.heuristic(state) + state.cost
    
    def add_states(self, succ, closed):
        for state in succ:
            hc = self.astar(state)
            f = [x[1] for x in self.states]
            if state not in closed and state not in f:
                self.add_state(state)
            elif state in f:
                idx = f.index(state)
                if hc < self.astar(self.states[idx][1]):
                    self.states[idx][0] = hc
            elif state in closed:
                idx = closed.index(state)
                if hc < self.astar(closed[idx]):
                    closed.remove(state)
                    self.add_state(state)

    def __repr__(self):
        s = type(self).__name__ + ': '
        s += str(len(self.states)) + ' untested, '
        s += str(self.num_tested) + ' tested, '
        s += 'heuristic ' + self.heuristic.__name__
        return s
    
    def find_solution(self, init_state):
        self.add_state(init_state)
        solution = [None, None]
        closed = []
        while self.states != []:
            hc, s = self.next_state()
            self.num_tested += 1
            print("Number of states tested: ", self.num_tested, end="\r")
            #print("Length of states: ", len(self.states), end="\r")
            #print(s.board, end="\r")
            if s.is_goal():
                print("A solution has been found.")
                if solution[0] == None or hc < solution[0]:
                    solution = [hc, s] 

            if  solution[0] != None and hc > solution[0]:
                print("The best solution has been found.")
                print("Number of states tested: ", self.num_tested)
                print("Length of states: ", len(self.states))
                return solution[1], self.num_tested, len(self.states)
            
            succ = s.successors()
            self.add_states(succ, closed)
            closed.append(s)
            
        return None, None, None

