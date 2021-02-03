
require_relative '../lib/pieces'
require_relative '../lib/create_pieces'
require_relative '../lib/move_validation'
require_relative '../lib/checkmate'

class Chess
  include CreatePieces
  include MoveValidation
  include Check
  include Mate

  attr_reader :board, :current_player, :selected_piece, :white_king, :black_king
  attr_writer :board, :white_king

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @current_player = 'white'
    @selected_piece = []
    @white_king = []
    @black_king = []
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
# game.set_board
# game.board[7][4] = nil
game.board[3][3] = King.new('white', [3, 3])
game.white_king = [3, 3]
game.board[6][1] = Knight.new('black', [6, 1])
game.board[1][5] = Knight.new('black', [1, 5])
game.board[3][1] = Rook.new('black', [3, 1])
game.board[6][3] = Rook.new('black', [6, 3])
game.board[3][5] = Rook.new('black', [3, 5])
game.board[1][1] = Queen.new('white', [1, 1])
game.board[2][5] = Queen.new('black', [2, 5])
game.board[7][7] = Bishop.new('white', [7, 7])

# game.board.each { |row| p row }

# puts game.check? ? "#{game.current_player.capitalize} King IS in check." : "#{game.current_player.capitalize} King IS NOT in check"
p game.checkmate?
p game.white_king
# game.board.each { |row| p row }
