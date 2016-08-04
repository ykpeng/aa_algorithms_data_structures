require_relative 'graph'
require_relative 'priority_map'

# O(|V| + |E|*log(|V|)).
def dijkstra2(source)
  shortest_paths = {}
  possible_paths = PriorityMap.new do |data1, data2|
    data1[:cost] <=> data2[:cost]
  end
  possible_paths[source] = { cost: 0, last_edge: nil }

  while !possible_paths.empty?
    vertex, data = possible_paths.extract
    min_cost = data[:cost]
    shortest_paths[vertex] = data
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
