

def file_reader(file):
    edge_count = 0
    vertex_count = 0
    edges = []
    with open(file, 'r') as f:
        lines = f.readlines()
        for line in lines:
            if line[0] == 'c':
                print(line, end='')
            elif line[0] == 'p':
                line = line.split(' ')
                vertex_count = int(line[2])
                edge_count = int(line[3])
            elif line[0] == 'e':                
                line = line.split(' ')
                edge = (int(line[1]), int(line[2]))            
                edges.append(edge)
            else:   
                print('Invalid line')
    return vertex_count, edge_count, edges
        
# vertex_count, edge_count, edges = file_reader('example.co1')
# print('Vertex count:', vertex_count)
# print('Edge count:', edge_count)
# print('Edges:', edges)