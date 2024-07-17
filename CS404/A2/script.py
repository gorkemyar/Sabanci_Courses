resultMatrix = [[0 for _ in range(7)] for _ in range(7)]

# islands = [[1, 1], [1, 3], [1, 6], [3, 1], [3, 3], [5, 1], [5, 3], [5, 6], [6, 3], [6, 5], [7, 3]]

BB = [[ 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0 ],
[ 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0 ],
[ 0, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0 ],
[ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 ],
[ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0 ],
[ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0 ],
[ 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0 ],
[ 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0 ],
[ 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1 ],
[ 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 ],
[ 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 ]]
islands = [(1, 1), (1, 3), (1, 6), (3, 1), (3, 3), (5, 1), (5, 3), (5, 6), (6, 3), (6, 5), (7, 3)]

# BB = [[ 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0 ],
# [ 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
# [ 0, 2, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0 ],
# [ 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
# [ 1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0 ],
# [ 0, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 0, 0 ],
# [ 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0 ],
# [ 0, 0, 0, 0, 0, 1, 2, 0, 1, 1, 0, 0, 0 ],
# [ 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 ],
# [ 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0 ],
# [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ],
# [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ],
# [ 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0 ]]

# islands = [(1, 1), (1, 3), (1, 6), (1, 7), (3, 1), (3, 3), (5, 1), (5, 3), (5, 6), (6, 3), (6, 5), (7, 3), (7, 6)]

# BB = [[ 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
# [ 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
# [ 0, 0, 0, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0 ],
# [ 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ],
# [ 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 ],
# [ 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
# [ 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0 ],
# [ 0, 0, 0, 0, 0, 0, 1, 0, 2, 0, 0, 0, 0, 0, 0 ],
# [ 0, 0, 0, 0, 1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0 ],
# [ 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0 ],
# [ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0 ],
# [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 1, 0, 0 ],
# [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 2, 0 ],
# [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 0, 1 ],
# [ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0 ]]

#islands = [(1, 1), (1, 3), (1, 5), (1, 7), (2, 3), (3, 1), (4, 1), (4, 2), (4, 3), (4, 5), (6, 1), (6, 2), (7, 2), (7, 5), (7, 7)]


islands = [ list(island) for island in islands]
# BB = [[0,1,1,0],
#       [1,0,0,1],
#       [1,0,0,1],
#       [0,1,1,0]]


horizontalSigns = ["a", "-", "="]
verticalSigns = ["a", "|", "x"]
for islandIndex, bbrow in enumerate(BB):
    for bridgeTo, connect in enumerate(bbrow):
        islandRow = islands[islandIndex][0]-1
        islandCol = islands[islandIndex][1]-1
        resultMatrix[islandRow][islandCol] += connect


for islandIndex, bbrow in enumerate(BB):
    for bridgeTo, connect in enumerate(bbrow):
        islandRow = islands[islandIndex][0]-1
        islandCol = islands[islandIndex][1]-1
        bridgeToRow = islands[bridgeTo][0]-1
        bridgeToCol = islands[bridgeTo][1]-1
        if connect > 0:
            if islandCol == bridgeToCol:
                if(islandRow+1 < bridgeToRow):
                    for vertical in range(islandRow+1, bridgeToRow):
                        resultMatrix[vertical][islandCol] = verticalSigns[connect]
                elif(islandRow+1 == bridgeToRow):
                    aRowofZeros = [ resultMatrix[islandRow][i] if resultMatrix[islandRow][i] in verticalSigns else resultMatrix[islandRow+1][i] if resultMatrix[islandRow+1][i] in verticalSigns else 0 for i in range(len(resultMatrix[0])) ]
                    resultMatrix.insert(bridgeToRow, aRowofZeros)
                    resultMatrix[bridgeToRow][islandCol] = verticalSigns[connect]
                    for island in islands:
                        if island[0] > bridgeToRow:
                            island[0] +=1
            if islandRow == bridgeToRow:
                if(islandCol+1 < bridgeToCol):
                    for horizontal in range(islandCol+1, bridgeToCol):
                        resultMatrix[islandRow][horizontal] = horizontalSigns[connect]
                elif(islandCol+1 == bridgeToCol):
                    for i in range(len(resultMatrix)):
                        resultMatrix[i].insert(bridgeToCol, resultMatrix[i][islandCol] if resultMatrix[i][islandCol] in horizontalSigns else resultMatrix[i][islandCol+1] if resultMatrix[i][islandCol+1] in horizontalSigns else 0)
                    resultMatrix[islandRow][bridgeToCol] = horizontalSigns[connect]
                    for island in islands:
                        if island[1] > bridgeToCol:
                            island[1] +=1

for row in resultMatrix:
    for item in row:
        print(item, end="   ")
    print()
        