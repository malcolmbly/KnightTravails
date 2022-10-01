# NOTE: use an unweighted undirected graph
# each point has it's key as the position, then a list of potential moves
# we will use BFS to find the shortest possible path.
# game board is 0-7 on X and Y axis
# 0, 0 is bottom left
# 7, 0 is top left
# need to use a queue to implement the BFS

class KnightsTravails
  class ChessNode
    include Comparable
    attr_reader :position
    attr_accessor :parents

    def initialize(position, path_taken = [])
      # position is a 2d array [row, column]
      @position = position
      @parents = path_taken
    end

    def valid_node?(row, column)
      row <= 7 && row >= 0 && column <= 7 && column >= 0
    end

    def <=>(other)
      sum_diff = @position.sum <=> other.position.sum
      return sum_diff if sum_diff != 0

      @position[0] <=> other.position[0]
    end

    def find_connected_nodes
      permutations = [[2, 1], [2, -1], [-2, 1], [-2, -1],
                      [1, 2], [1, -2], [-1, 2], [-1, -2]]
      permutations.reduce([]) do |connected_arr, move|
        move[0] += @position[0]
        move[1] += @position[1]
        
        connected_arr.append(ChessNode.new(move, [*@parents, self])) if valid_node?(move[0], move[1])
        connected_arr
      end
    end

    def to_s
      return "#{@position} path to #{@parents.map(&:position)}"
    end
  end

  attr_accessor :starting_node, :ending_node, :already_visited

  def initialize(starting_position, ending_position)
    @starting_node = ChessNode.new(starting_position)
    @ending_node = ChessNode.new(ending_position)
    @already_visited = [starting_position]
  end

  def find_shortest_path
    queue = @starting_node.find_connected_nodes
    
    until queue.empty?
      current_node = queue.shift
      already_visited.include?(current_node.position) ? next : already_visited.append(current_node.position)
      if current_node == @ending_node
        current_node.parents.append(current_node)
        return current_node.parents.map(&:position)
      end
      unvisited_neighbors = current_node.find_connected_nodes.select do
        |node| !already_visited.include?(node.position)
      end
      queue.concat(unvisited_neighbors)
    end
  end
end

Kt = KnightsTravails.new([3, 3], [3, 4])
p Kt.find_shortest_path
