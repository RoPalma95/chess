
require_relative '../lib/pieces'
require_relative '../lib/create_pieces'
require_relative '../lib/move_validation'

class Chess
  include CreatePieces
  include MoveValidation

  attr_reader :board, :current_player, :selected_piece

  def initialize
    @board = Array.new(8) { Array.new(8) { " " } }
    @current_player = 'White'
    @selected_piece = []
  end

  def play_game
  end

  def set_board
    create_pieces
  end

  def make_move
    puts "#{current_player}'s turn. Please select a piece to move >>"
    select_piece
  end

  def select_piece
    piece = gets.chomp.upcase
    until valid_piece?(piece)
      puts 'Please select a valid piece (R, N, B, Q, K or P) >> '
      piece = gets.chomp.upcase
    end
    @selected_piece << piece
    initial_position(piece) unless ['Q', 'K'].include?(piece)
  end

  def initial_position(piece)
    puts "Which #{piece} would you like to move? (Input its current square)>> "
    position = gets.chomp.upcase
    until valid_init_pos?(piece, position)
      puts "Please select a square that contains a #{piece}"
      position = gets.chomp.upcase
    end
    @selected_piece << position
  end
end

game = Chess.new
game.set_board
game.select_piece
p game.selected_piece
# game.initial_position
# p game.selected_piece
# game.board.each do |row|
#   p row
# end
