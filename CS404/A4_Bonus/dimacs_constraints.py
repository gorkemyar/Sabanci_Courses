def vertex_color_number(vertex, color, color_count):
    return (vertex-1) * color_count + color

def color_every_vertex(vertex_count, color_count):
    constraints = []
    for vertex in range(1, vertex_count + 1):
        vertex_constraints = []
        for color in range(1, color_count + 1):
            vertex_constraints.append(vertex_color_number(vertex, color, color_count))
        constraints.append(vertex_constraints)
    return constraints

def color_vertex_with_exactly_one_color(vertex_count, color_count):
    constraints = []
    for vertex in range(1, vertex_count + 1):
        for c1 in range(1, color_count + 1):
            for c2 in range(c1+1, color_count + 1):
                constraints.append([-vertex_color_number(vertex, c1, color_count), -vertex_color_number(vertex, c2, color_count)])
    return constraints

def adjacent_vertices_have_different_colors(edges, color_count):
    constraints = []
    for edge in edges:
        v1, v2 = edge
        for color in range(1, color_count + 1):
            constraints.append([-vertex_color_number(v1, color, color_count), -vertex_color_number(v2, color, color_count)])
    return constraints
