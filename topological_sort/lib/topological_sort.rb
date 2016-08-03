require_relative 'graph'

# Implementing topological sort using both Khan's and Tarian's algorithms

# Khan's
def topological_sort(vertices)
  in_edge_counts = {}
  no_ins = []

  vertices.each do |vertex|
    in_edge_counts[vertex] = vertex.in_edges.length
    no_ins << vertex if vertex.in_edges.empty?
  end

  res = []
  while !no_ins.empty?
    u = no_ins.shift
    res << u

    u.out_edges.each do |edge|
      to_vertex = edge.to_vertex
      in_edge_counts[to_vertex] -= 1
      no_ins << to_vertex if in_edge_counts[to_vertex] == 0
    end
  end

  res
end

# Tarjan's
def topological_sort(vertices)
  res = []
  explored = Set.new

  vertices.each do |vertex|
    if !explored.include?(vertex)
      dfs_visit(vertex, explored, res)
    end
  end

  res
end

def dfs_visit(vertex, explored, res)
  explored << vertex

  vertex.out_edges.each do |edge|
    to_vertex = edge.to_vertex
    if !explored.include?(to_vertex)
      dfs_visit(to_vertex, explored, res)
    end
  end

  res.unshift(vertex)
end
