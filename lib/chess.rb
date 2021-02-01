
require_relative '../lib/pieces'
require_relative '../lib/create_pieces'
require_relative '../lib/move_validation'

class Chess
  include CreatePieces
  include MoveValidation

  attr_reader :board, :current_player, :selected_piece
  attr_writer :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @current_player = 'white'
    @selected_piece = []
  end

  def play_game
  end

  def set_board
    create_pieces
  end

  def make_move
    puts "#{current_player.upcase}'s turn. Please select a piece to move >>"
    select_piece
    puts "Where will you move your #{selected_piece.join('')}? >> "
    new_position = input_position
    # update_board(new_position)
  end

  def select_piece
    piece = gets.chomp.upcase
    until valid_piece?(piece)
      puts 'Please select a valid piece (R, N, B, Q, K or P) >> '
      piece = gets.chomp.upcase
    end
    @selected_piece << piece
    initial_position(piece)
  end

  def initial_position(piece)
    puts "Which #{piece} would you like to move? (Input its current square)>> "
    position = gets.chomp.upcase
    until valid_init_pos?(piece, position)
      puts "Please select a square that contains a #{current_player} #{piece}"
      position = gets.chomp.upcase
    end
    @selected_piece << position
  end

  def input_position
    position = gets.chomp.upcase
    until valid_end_pos?(position)
      puts "Please select a valid destination >> "
      position = gets.chomp.upcase
    end
    position
  end

  # def update_board(position)
  # end

  def change_player
    @current_player = current_player == 'white' ? 'black' : 'white'
    @selected_piece.clear
  end
end

game = Chess.new
game.set_board
game.board[4][6] = Pawn.new('black', [4, 6])
p game.make_move
# game.select_piece
# p game.selected_piece
