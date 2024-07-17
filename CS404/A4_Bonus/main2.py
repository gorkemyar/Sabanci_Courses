from file_reader import file_reader
from dimacs_constraints import *
import sys
import os

if __name__ == "__main__":
   # get an input from command line
    file_name = 'example.co3'
    vertex_count, edge_count, edges = file_reader(file_name)
    
    sat = False
    res = 0
    for color_count in range(1, vertex_count+1):
        constraints = []
        constraints += color_every_vertex(vertex_count, color_count)
        constraints += color_vertex_with_exactly_one_color(vertex_count, color_count)
        constraints += adjacent_vertices_have_different_colors(edges, color_count)


        with open('./output/cnf2_'+file_name+'.txt', 'w') as f:
            f.write('p cnf {} {}\n'.format(vertex_count * color_count, len(constraints)))
            for constraint in constraints:
                f.write(' '.join(map(str, constraint)) + ' 0\n')
        
        #execute the command ./kissat out.cnf using os write the output to a file
        os.system("./kissat "+ './output/cnf2_'+file_name+'.txt' + " > " + './output/out2_'+file_name+'.txt')

        #read the output file and print the output
        with open('./output/out2_'+file_name+'.txt', 'r') as f:
            lines = f.readlines()
            for line in lines:
                if line[0] == 's':
                    if line.split(' ')[1] == 'SATISFIABLE\n':
                        print(line, end='')
                        sat = True
                        break
        print('SAT' if sat else 'UNSAT')
        if sat:
            res = color_count
            break

    print('The chromatic number is:', res)