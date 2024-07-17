
class Board:
    def __init__(self, board):
        self.board = board
        self.agent = (None, None)
        for r in range(len(board)):
            for c in range(len(board[0])):
                if board[r][c] == "S":
                    self.agent = (r, c)
            
    def __repr__(self) -> str:
        s = ''
        for row in self.board:
            for cell in row:
                s += str(cell) + ' '
            s += '\n'
        return s

    def color_direction(self, direction):
        r, c = self.agent
        if direction == 'up':
            for i in range(r, -1, -1):
                if self.board[i][c] == "X":
                    self.board[i+1][c] = "S"
                    self.agent = (i+1, c)
                    break
                if i == 0:
                    self.board[i][c] = "S"
                    self.agent = (i, c)
                    break
                self.board[i][c] = 1
                
        elif direction == 'down':
            for i in range(r, len(self.board)):
                if self.board[i][c] == "X":
                    self.board[i-1][c] = "S"
                    self.agent = (i-1, c)
                    break
                if i == len(self.board) - 1:
                    self.board[i][c] = "S"
                    self.agent = (i, c)
                    break
                self.board[i][c] = 1

        elif direction == 'left':
            for i in range(c, -1, -1):
                if self.board[r][i] == "X":
                    self.board[r][i+1] = "S"
                    self.agent = (r, i+1)
                    break
                if i == 0:
                    self.board[r][i] = "S"
                    self.agent = (r, i)
                    break
                self.board[r][i] = 1
      
        elif direction == 'right':
            for i in range(c, len(self.board[0])):
                if self.board[r][i] == "X":
                    self.board[r][i-1] = "S"
                    self.agent = (r, i-1)
                    break
                if i == len(self.board[0]) - 1:
                    self.board[r][i] = "S"
                    self.agent = (r, i)
                    break
                self.board[r][i] = 1
        else:
            raise ValueError("Invalid direction")

    def copy(self):
        b =  [[cell for cell in row] for row in self.board]
        return Board(b)
    
    def uncolored_cells(self):
        tot = 0
        for row in self.board:
            for cell in row:
                if cell == 0:
                    tot += 1
        return tot
    def border_cells(self):
        tot = 0
        for r in range(len(self.board)):
            for c in range(len(self.board[0])):
                if self.board[r][c] == "X":                    
                    tot += 1
        return tot
    
    def __eq__(self, other):
        if not isinstance(other, Board):
            return False
        if len(self.board) != len(other.board):
            return False
        if len(self.board[0]) != len(other.board[0]): # assume there is at least one row
            return False

        for i in range(len(self.board)):
            for j in range(len(self.board[i])):
                if self.board[i][j] != other.board[i][j]:
                    return False
                
        return True

    def get_agent(self):
        return self.agent
    
    