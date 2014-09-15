require_relative 'tile'

class Board

  GRID_SIZE = 9
  NUM_BOMBS = 12
  ALL_MOVES = [[1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1],[0,1],[1,1]]

  attr_reader :board

  def self.create_board(grid_size,num_bombs)
    board = Array.new(grid_size) { Array.new(grid_size," ") }
    bombs_array = seed_bombs(board, num_bombs)
    untiled_board = seed_board(board,bombs_array)
    seed_tiles(untiled_board)
  end

  def self.seed_bombs(array,num_bombs)
    array = array.flatten
    bombs = Array.new(num_bombs,"b")
    (array.drop(num_bombs) + bombs).shuffle
  end

  def self.seed_board(board,bombs_array)
    board.map do |row|
      row.map do |cell|
        cell = bombs_array.shift
      end
    end
  end

  def self.seed_tiles(untiled_board)
    untiled_board.map.with_index do |row, col_idx|
      row.map.with_index do |elem, row_idx|
        pos = [col_idx, row_idx]
        neighbors = find_neighbors(untiled_board, pos)
        if elem == "b"
          Tile.new(elem, pos, neighbors)
        else
          value = num_neighboring_bombs(untiled_board, pos, neighbors)
          value = '_' unless value > 0
          Tile.new(value, pos, neighbors)
        end
      end
    end
  end

  def self.num_neighboring_bombs(board, pos, neighbors)
    num_bombs = 0

    neighbors.each do |pos|
      num_bombs += 1 if board[pos[0]][pos[1]] == "b"
    end

    num_bombs
  end

  def self.find_neighbors(board, pos)
    neighbors = []

    ALL_MOVES.each do |move| #[1,-1]
      neighbor_pos = [move[0] + pos[0], move[1] + pos[1]]
      unless board[neighbor_pos[0]].nil? ||
      board[neighbor_pos[0]][neighbor_pos[1]].nil? ||
      neighbor_pos[0] < 0 || neighbor_pos[1] < 0
        neighbors << neighbor_pos
      end
    end

    neighbors
  end

  def initialize(grid_size = GRID_SIZE, num_bombs = NUM_BOMBS)
    @board = Board.create_board(grid_size, num_bombs)
  end

  def render
    board.each do |row|
      puts row.map { |cell|
        cell.show_status == 's' ? cell.value : cell.show_status
      }.join("  ")
    end
    nil
  end

  def inspect
    board.each{|row| puts row.map {|cell| cell.value}.join("  ") }
    nil
  end

end