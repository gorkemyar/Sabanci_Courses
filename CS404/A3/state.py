from board import *
# AI is always player1
class State:
    def __init__(self, board, predecessor, player1 = 0, player2 = 0, turn = 0): # turn = 0 means player1's turn, turn = 1 means player2's turn
        self.board = board.copy()
        self.predecessor = predecessor
        self.player1 = player1
        self.player2 = player2
        self.turn = turn

    def __repr__(self) -> str:
        s = self.board.__repr__()
        s += "Player1: " + str(self.player1) + "\n"
        s += "Player2: " + str(self.player2) + "\n"
        return s
    
    def __eq__(self, __value: object) -> bool:
        if not isinstance(__value, State):
            return False
        return self.board == __value.board

    def print_moves(self):
        if self.predecessor is not None:
            self.predecessor.print_moves()
        #print("Cost:", self.cost, "Move:", self.move)
        #print(self.board)
        
    def getTotalBridges(self):
        return self.board.getTotalBridges()
    
    
    
    def is_terminal(self):
        if len(self.board.get_empty_cells()) > 0:
            return False

        cells = self.board.enumerate_cells()
        for i in range(len(cells)):
            for j in range(i+1, len(cells)):
                if self.board.bridge_possible_between_cells(cells[i], cells[j]):
                    return False
        return True
     
    
    def successors(self):
        if self.is_terminal():
            return []

        successors = []

        empty_cells = self.board.get_empty_cells()
        for cell in empty_cells:
            r, c = cell.get_position()
            new_board = self.board.copy()
            new_board.board[r][c].value = 3
            successors.append(State(new_board, self, self.player1, self.player2, 1-self.turn))

            new_board = self.board.copy()
            new_board.board[r][c].value = 4
            successors.append(State(new_board, self, self.player1, self.player2, 1-self.turn))
        
        cells = self.board.enumerate_cells()
        for i in range(len(cells)):
            for j in range(i+1, len(cells)):
                if self.board.bridge_possible_between_cells(cells[i], cells[j]):
                    new_board = self.board.copy()
                    new_board, score = new_board.add_bridge_between_cells(cells[i], cells[j])
                    if self.turn == 0:
                        p1 = self.player1 + score
                        p2 = self.player2 - score
                    else:
                        p1 = self.player1 - score
                        p2 = self.player2 + score
                    successors.append(State(new_board, self, p1, p2, 1-self.turn))
        # print("Successors: ", len(successors))
        # for s in successors:
        #     print(s)
        #     print("_________________________")
        # input()
        return successors
                
