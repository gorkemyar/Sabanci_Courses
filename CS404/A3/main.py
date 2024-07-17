from state import State
from player import Player
from ai import AI
from board import Board

if __name__ == "__main__":
    # b = [[1, ".", 1],
    #      [".", 0, "."],
    #      [".", 2, 0]]
    b = [[2, ".", ".", 2],
         [".", ".", ".", "."],
         [".", ".", ".", "."],
         [0, ".", ".", 2]]
    # b =[[".", 2, ".", 0, ".", "."],
    # [".", ".", ".", ".", ".", "."],
    # [".", 3, ".", ".", 3, "."],
    # [".", ".", ".", 0, ".", "."],
    # [".", ".", 1, ".", 1, "."],
    # [".", 2, ".", ".", ".", "."]]
    # b =[[".", 2, ".", 1, ".", ".", "."],
    #     [".", ".", ".", ".", ".", ".", "."],
    #     [".", ".", ".", 0, ".", ".", "."],
    #     [".", 4, ".", ".", 3, ".", "."],
    #     [".", ".", ".", ".", ".", ".", "."],
    #     [".", ".", 1, ".", 1, ".", "."],
    #     [".", 4, ".", ".", 4, ".", "."]]
    
    board = Board(b)
    state = State(board, None, 0, 0, 0)

    player1 = "Jarvis"
    player2 = "Tony Stark"
    
    print("_________________________")
    print(state)
    
    while not state.is_terminal():
        if state.turn == 0:
            ai = AI(state, player1)
            state = ai.make_move()  
        else:
            p2 = Player(state, player2)
            state = p2.make_move()
        print(state)
        print("_________________________")
        state.getTotalBridges()
        print("_________________________")
    print("Game Ends")
    if state.player1 > state.player2:
        print(player1, "wins")
    elif state.player1 < state.player2:
        print(player2, "wins")
    else:
        print("Draw")

""" # 6 x 6

b =[[".", 2, ".", 0, ".", "."],
    [".", ".", ".", ".", ".", "."],
    [".", 3, ".", ".", 3, "."],
    [".", ".", ".", 0, ".", "."],
    [".", ".", 1, ".", 1, "."],
    [".", 2, ".", ".", ".", "."]]

b =[[".", 2, ".", 0, ".", "."],
    [".", ".", ".", ".", ".", "."],
    [".", 4, ".", ".", 3, "."],
    [".", ".", ".", 0, ".", "."],
    [".", ".", 1, ".", 1, "."],
    [".", 4, ".", ".", 4, "."]]

"""