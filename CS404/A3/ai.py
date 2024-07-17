from state import State

class AI:
    def __init__(self, state, name):
        self.name = name
        self.state = state
    
    def make_move(self):
        #print("Player", self.name, "turn")
        best_val, best_move = maxEval(self.state, -float('inf'), float('inf'))
        #print("Best value: ", best_val)
        #print("Best move: ", best_move)
        return best_move
    
    
def maxEval(state, alpha, beta):
    if state.is_terminal():
        return state.player1, state
    s = state
    for child in state.successors():
        val, new_s = minEval(child, alpha, beta)
        if val > alpha:
            alpha = val
            s = child
        if alpha >= beta:
            return alpha, s
    return alpha, s

def minEval(state, alpha, beta):
    if state.is_terminal():
        return state.player1, state
    s = state
    for child in state.successors():
        val, new_s = maxEval(child, alpha, beta)
        if val < beta:
            beta = val
            s = child
        if alpha >= beta:
            return beta, s
    return beta, s