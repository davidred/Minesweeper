require_relative 'tile'

class Board

  GRID_SIZE = 9
  NUM_BOMBS = 12
  ALL_MOVES = [[1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1],[0,1],[1,1]]

  attr_reader :board

  def self.create_board(grid_size,num_bombs)
    board = Array.new(grid_size) { Array.new(grid_size,nil) }
    bombs_array = seed_bombs(board, num_bombs)
    seed_board(board,bombs_array)


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


  def initialize(grid_size = GRID_SIZE, num_bombs = NUM_BOMBS)
    @board = Board.create_board(grid_size,num_bombs)
  end

end