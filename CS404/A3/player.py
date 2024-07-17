from state import State

class Player:
    def __init__(self, state, name):
        self.state = state
        self.name = name
    
    def make_move(self):
        new_board = None
        while new_board == None:
            print("Player", self.name, "turn")
            print("Options:")
            print("     1. Add value to an empty island")
            print("     2. Add horizontal or vertical bridge between two islands")
            choice = int(input("Enter your choice: "))
            player1 = self.state.player1
            player2 = self.state.player2
            if choice == 1:
                r = int(input("Enter row: "))
                c = int(input("Enter column: "))
                if self.state.board.board[r][c].value != 0:
                    print("Cell is not empty")
                    continue
                val = int(input("Enter value: "))
                if val != 3 and val != 4:
                    print("Invalid value")
                    continue
                new_board = self.state.board.copy()
                new_board.board[r][c].value = val
            elif choice == 2:
                print(type(self.state.board))
                r1 = int(input("Enter row of first island: "))
                c1 = int(input("Enter column of first island: "))
                r2 = int(input("Enter row of second island: "))
                c2 = int(input("Enter column of second island: "))
                
                if self.state.board.bridge_possible_between_cells(self.state.board.board[r1][c1], self.state.board.board[r2][c2]) == False:
                    print("Bridge not possible")
                    continue
                
                new_board = self.state.board.copy()
                new_board, score = new_board.add_bridge_between_cells(self.state.board.board[r1][c1], self.state.board.board[r2][c2])
                player1 -= score 
                player2 += score

        return State(new_board, self.state, player1, player2, 1-self.state.turn)
     
