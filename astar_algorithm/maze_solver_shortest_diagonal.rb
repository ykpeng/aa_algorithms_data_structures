def astar(nodes, start, goal, maze)
  unexplored = [start]
  explored = []
  parents = {start => nil}

  gscores = {start => 0}
  hscores = {start => find_hscore(start, goal)}
  fscores = {start => gscores[start] + hscores[start]}

  while !unexplored.empty?
    current = minf_node(unexplored, fscores)
    if current == goal
      return display_path(parents, current, start, maze)
    end
    unexplored.delete(current)
    explored << current
    neighbors = find_neighbors(nodes, current)
    neighbors.each do |neighbor|
      if !explored.include?(neighbor)
        if !unexplored.include?(neighbor)
          parents[neighbor] = current
          gscores[neighbor] = find_gscore(neighbor, current, gscores)
          unexplored << neighbor
        else
          if find_gscore(neighbor, current, gscores) < gscores[neighbor]
            parents[neighbor] = current
            gscores[neighbor] = find_gscore(neighbor, current, gscores)
          end
        end
        hscores[neighbor] = find_hscore(neighbor, goal)
        fscores[neighbor] = gscores[neighbor] + hscores[neighbor]
      end
    end
  end
  p "No solution"
end

def display_path(parents, current, start, maze)
  previous = parents[current]
  while previous != start
    maze[previous[0]][previous[1]] = "X"
    previous = parents[previous]
  end
  display_maze(maze)
end

def display_maze(maze)
  maze.each do |row|
    puts row.join("")
  end
  puts
end

def minf_node(unexplored, fscores)
  minnode = unexplored[-1]
  minvalue = fscores[unexplored[-1]]
  unexplored.each do |node|
    if fscores[node] < minvalue
      minvalue = fscores[node]
      minnode = node
    end
  end
  minnode
end

def find_gscore(node, parent, gscores)
  if (node[0] - parent[0]).abs == (node[1] - parent[1]).abs
    score = 14
  else
    score = 10
  end
  gscores[parent] + score
end

def find_hscore(node, goal)
  (goal[0] - node[0]).abs + (goal[1] - node[1]).abs - 1
end

def find_start(maze)
  maze.each_index do |i|
    maze[i].each_index do |j|
      if maze[i][j] == "S"
        return [i, j]
      end
    end
  end
end

def find_end(maze)
  maze.each_index do |i|
    maze[i].each_index do |j|
      if maze[i][j] == "E"
        return [i, j]
      end
    end
  end
end

def find_neighbors(nodes, node)
  directions = [[1, -1], [1, 0], [1, 1], [0, -1], [0, 1], [-1, -1], [-1, 0], [-1, 1]]
  results = []
  directions.each do |direction|
    neighbor = [node[0] + direction[0], node[1] + direction[1]]
    if nodes.include?(neighbor)
      results << neighbor
    end
  end
  results
end

if $PROGRAM_NAME == __FILE__
  maze = []
  File.open("maze.txt", "r") do |f|
    f.each_line do |line|
      maze << line.strip.split("")
    end
  end
  nodes = []
  maze.each_index do |i|
    maze[i].each_index do |j|
      if maze[i][j] != "*"
        nodes << [i, j]
      end
    end
  end
  start = find_start(maze)
  goal = find_end(maze)
  astar(nodes, start, goal, maze)
end
