require_relative 'board'

class Minesweeper

  GRID_SIZE = 9
  NUM_BOMBS = 12

  attr_reader :game_board

  def intialize(grid_size = GRID_SIZE, num_bombs = NUM_BOMBS)
    @game_board = Board.new(grid_size, num_bombs)
  end

  def run
    until over?
      game_board.render
      take_turn
    end
  end

  def take_turn
    move = get_move
    move_type = move[0]
    pos = move[1]

    process_move(move_type, pos)
  end

  def get_move
    p "enter your move: "
    move = gets.chomp
    unless move =~ /\A[fr] \d,\d\Z/
      puts "Invalid move, enter move type and position in form of: (r 1,2)"
      p "enter your move: "
      move = gets.chomp
    end
    pos = [move[2],move[4]]
    move_type = move[0]
    [move_type, pos]
  end

  def process_move(move_type, pos)
    game_board[pos[0]][pos[1]]
  end

  def reveal(pos)
  end

  def over?
  end

end