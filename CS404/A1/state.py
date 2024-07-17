from board import *

MOVES = ['up', 'down', 'left', 'right']

class State:
    def __init__(self, board, predecessor, move) -> None:
        self.board = board.copy()
        self.predecessor = predecessor
        self.move = move
        self.num_moves = 0
        if self.predecessor != None:
            self.num_moves = self.predecessor.num_moves + 1        
        self.cost = 0
        self.init_cost()
    
    def init_cost(self):
        if self.predecessor == None:
            self.cost = 0
            return
        rp, cp = self.predecessor.board.get_agent()
        r, c = self.board.get_agent()
        self.cost = self.predecessor.cost + abs(rp - r) + abs(cp - c)


    def is_goal(self):
        return self.board.uncolored_cells() == 0

    def __repr__(self) -> str:
        s = self.board.__repr__()
        s += f"Cost: {self.num_moves}\n"
    
    def print_moves(self):
        if self.predecessor is not None:
            self.predecessor.print_moves()
        print("Cost:", self.cost, "Move:", self.move)
        print(self.board)
    
    def is_cycle(self):
        state = self.predecessor
        while state is not None:
            if self.board == state.board:
                return True
            state = state.predecessor
        return False
    
    def successors(self):
        r, c = self.board.get_agent()
        successors = []
        for move in MOVES:
            new_board = self.board.copy()
            new_board.color_direction(move)
            new_state = State(new_board, self, move)
            if not new_state.is_cycle():
                successors.append(new_state)
        return successors
                
    def __eq__(self, __value: object) -> bool:
        if not isinstance(__value, State):
            return False
        return self.board == __value.board
    
    def __lt__(self, other):
        return True