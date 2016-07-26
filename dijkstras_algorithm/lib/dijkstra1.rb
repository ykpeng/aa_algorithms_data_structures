require_relative 'graph'

# O(|V|**2 + |E|).
def dijkstra1(source)
  shortest_paths = {}
  possible_paths = {
    source => { total_cost: 0, prev_edge: nil }
  }

  until possible_paths.empty?
    extension = {
      edge: nil,
      total_cost: Float::INFINITY,
      prev_vertex: nil
    }

    shortest_paths.keys.each do |vertex|
      vertex.out_edges.each do |edge|
        next_vertex = (edge.from_vertex == vertex) ? edge.to_vertex : edge.from_vertex

        next if shortest_paths.include?(next_vertex)

        total_cost = shortest_paths[vertex][:total_cost] + edge.cost
        if total_cost < extension[:total_cost]
          extension = {
            edge: edge,
            total_cost: total_cost,
            prev_vertex: vertex
          }
        end
      end
    end

    break if extension[:edge].nil?

    shortest_paths[extension[:vertex]] = {
      prev_edge: extension[:edge],
      total_cost: extension[:total_cost]
    }
  end

  shortest_paths
end
