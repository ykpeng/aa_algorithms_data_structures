require_relative 'graph'

# O(|V|**2 + |E|).
def dijkstra1(source)
  shortest_paths = {}
  possible_paths = {}
  possible_paths[source] = { cost: 0, last_edge: nil }

  while !possible_paths.empty?
    vertex, data = possible_paths.min_by { |vertex, data| data[:cost] }
    min_cost = data[:cost]
    shortest_paths[vertex] = possible_paths[vertex]
    possible_paths.delete(vertex)
    vertex.out_edges.each do |edge|
      if !shortest_paths.include?(edge.to_vertex)
        relax(vertex, edge, possible_paths, min_cost)
      end
    end
  end

  shortest_paths
end

def relax(vertex, edge, possible_paths, min_cost)
  to_vertex = edge.to_vertex
  if !possible_paths[to_vertex] || possible_paths[to_vertex][:cost] > min_cost + edge.cost
    possible_paths[to_vertex] = { cost: min_cost + edge.cost, last_edge: edge }
  end
end
