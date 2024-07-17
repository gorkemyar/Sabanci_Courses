
class Cell:
    def __init__(self, r, c, value, bridges = 0):
        self.r = r
        self.c = c
        self.value = value
        self.bridges = bridges

    def copy(self):
        return Cell(self.r, self.c, self.value, self.bridges)
        
    def __repr__(self) -> str:
        return str(self.value)
    
    def __eq__(self, other):
        if not isinstance(other, Cell):
            return False
        return self.r == other.r and self.c == other.c and self.value == other.value
    
    def get_position(self):
        return (self.r, self.c)
    
    def get_value(self):
        return self.value
    
    def get_bridges(self):
        return self.bridges
    
    def add_bridge(self):
        self.bridges += 1
    
    def is_full(self):
        return self.bridges == self.value
    
    def is_island(self):
        return isinstance(self.value, int)
    
    def is_labeled_island(self):
        return isinstance(self.value, int) and self.value > 0

class Board:
    def __init__(self, board):
        self.board = [[Cell(i, j, board[i][j]) for j in range(len(board[0]))] for i in range(len(board))]
          
    def __repr__(self) -> str:
        s = ''
        for i in range(len(self.board)):
            for j in range(len(self.board[i])):
                s += str(self.board[i][j]) + " "
            s += "\n"
        return s
    
    def getTotalBridges(self):
        for i in range(len(self.board)):
            for j in range(len(self.board[i])):
                if(self.board[i][j].is_island()):
                    print("island row:" + str(i) + " col: " + str(j) + " has " + str(self.board[i][j].bridges) + " bridges")
        
        

    def copy(self):
        b =  [[cell.copy() for cell in row] for row in self.board]
        new_ = Board([[]])
        new_.board = b
        return new_

    def get_empty_cells(self):
        empty_cells = []
        for i in range(len(self.board)):
            for j in range(len(self.board[i])):
                if self.board[i][j].is_island() and self.board[i][j].get_value() == 0:
                    empty_cells.append(self.board[i][j])
        return empty_cells
    
    def enumerate_cells(self):
        cells = []
        for i in range(len(self.board)):
            for j in range(len(self.board[i])):
                if self.board[i][j].is_labeled_island():
                    cells.append(self.board[i][j])
        return cells
    
    def bridge_possible_between_cells(self, cell1, cell2):
        r1, c1 = cell1.get_position()
        r2, c2 = cell2.get_position()
        if cell1.is_full() or cell2.is_full():
            return False
        if cell1.is_island() == False or cell2.is_island() == False:
            return False
        if cell1 == cell2:
            return False
        if r1 == r2:
            if c1 > c2:
                c1, c2 = c2, c1

            all_dot = all(self.board[r1][c].get_value() == "." for c in range(c1+1, c2))
            all_line = all(self.board[r1][c].get_value() == "-" for c in range(c1+1, c2))
            return all_dot or all_line
           
        elif c1 == c2:
            if r1 > r2:
                r1, r2 = r2, r1
   
            all_dot = all(self.board[r][c1].get_value() == "." for r in range(r1+1, r2))
            all_line = all(self.board[r][c1].get_value() == "|" for r in range(r1+1, r2))
            return all_dot or all_line
        return False

    def add_bridge_between_cells(self, cell1, cell2):
        new_board = self.copy()
        score = 0
        r1, c1 = cell1.get_position()
        r2, c2 = cell2.get_position()
        if r1 == r2:
            new_board.board[r1][c1].add_bridge()
            new_board.board[r2][c2].add_bridge()
            if new_board.board[r1][c1].is_full():
                score += new_board.board[r1][c1].get_value()
            if new_board.board[r2][c2].is_full():
                score += new_board.board[r2][c2].get_value()

            if c1 > c2:
                c1, c2 = c2, c1
            if new_board.board[r1][c1+1].value == ".":
                for c in range(c1+1, c2):
                    new_board.board[r1][c].value = "-"                    
            elif new_board.board[r1][c1+1].value == "-":
                for c in range(c1+1, c2):
                    new_board.board[r1][c].value = "="
            
        elif c1 == c2:
            new_board.board[r1][c1].add_bridge()
            new_board.board[r2][c2].add_bridge()
            if new_board.board[r1][c1].is_full():
                score += new_board.board[r1][c1].get_value() 
            if new_board.board[r2][c2].is_full():
                score += new_board.board[r2][c2].get_value()

            if r1 > r2:
                r1, r2 = r2, r1
            if new_board.board[r1+1][c1].value == ".":
                for r in range(r1+1, r2):
                    new_board.board[r][c1].value = "|"
            elif new_board.board[r1+1][c1].value == "|":
                for r in range(r1+1, r2):
                    new_board.board[r][c1].value = "x"

        return new_board, score

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
    