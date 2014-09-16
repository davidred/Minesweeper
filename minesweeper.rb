#!/usr/bin/env ruby

require_relative 'board'
require 'yaml'

class Minesweeper

  GRID_SIZE = 9
  NUM_BOMBS = 12

  attr_reader :filename
  attr_accessor :game_board, :win_state

  def initialize(filename = 'save.txt', grid_size = GRID_SIZE, num_bombs = NUM_BOMBS)
    @filename = filename
    @game_board = Board.new(grid_size, num_bombs)
    @win_state = nil
  end

  def run
    until over?
      game_board.render
      take_turn
    end

    game_board.render
    puts
    puts "You #{win_state}!"
  end

  def take_turn
    move = get_move
    move_type = move[0]
    pos = move[1]
    process_move(move_type, pos)
  end

  def get_move
    p "enter your move: "
    move = $stdin.gets.chomp
    if move == 's'
      save_object = self.to_yaml
      File.open(filename,'w') do |f|
        f.puts(save_object)
      end
    end
    unless move =~ /\A[fr] \d,\d\Z/
      if move == 's'
        puts "You saved your game, now enter a move"
        move = $stdin.gets.chomp
      else
        puts "Invalid move, enter move type and position in form of: (r 1,2)"
        p "enter your move: "
        move = $stdin.gets.chomp
      end
    end
    puts
    pos = [move[2].to_i,move[4].to_i]
    move_type = move[0]
    [move_type, pos]
  end

  def process_move(move_type, pos)
    tile = game_board[pos]
    if move_type == 'r'
      tile.show_status = move_type if tile.value == 'b'
    end
    tile.show_status = move_type if move_type == 'f'
    reveal(tile) if move_type == "r" && tile.value != "b"
  end

  def reveal(tile)
    queue = []
    queue << tile
    until queue.empty?
      current_tile = queue.shift
      next if current_tile.show_status == 'r'
      if current_tile.value == "_"
        current_tile.show_status = "r"
        queue += current_tile.neighbors.map { |neighbor| game_board[neighbor] }
      else
        current_tile.show_status = "r"
        queue += current_tile.neighbors.select { |neighbor|
          game_board[neighbor].value == "_"
        }.map { |neighbor| game_board[neighbor] }
      end
    end
  end

  def over?
    @win_state = "won" if won?
    @win_state = "lost"  if lost?

    win_state
  end

  def lost?
    game_board.board.any? do |row|
      row.any? do |tile|
        tile.show_status == "r" && tile.value == "b"
      end
    end
  end

  def won?
    game_board.board.all? do |row|
      row.all? do |tile|
        (tile.show_status == "r" && tile.value != "b") ||
        (tile.show_status == 'f' && tile.value == 'b')
      end
    end
  end

end

if __FILE__ == $PROGRAM_NAME

  if ARGV[0].nil?
    g = Minesweeper.new
    g.run
  else
    filepath = ARGV[0]
    begin
      contents = File.read(filepath).chomp
    rescue SystemCallError
      puts "filepath does not exist"
      p "Please enter valid filepath"
      filepath = $stdin.gets.chomp
      retry
    end

    if contents.empty?
      g = Minesweeper.new(ARGV[0])
      g.run
    else
      g = YAML::load(contents)
      g.run
    end
  end
end