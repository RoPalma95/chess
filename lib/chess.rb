
require_relative '../lib/pieces'
require_relative '../lib/create_pieces'
require_relative '../lib/move_validation'
require_relative '../lib/checkmate'

class Chess
  include CreatePieces
  include MoveValidation
  include Check
  include Mate

  attr_reader :board, :current_player, :selected_piece, :white, :black, :checking_piece
  attr_writer :board, :white, :black

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @current_player = 'white'
    @selected_piece = []
    @white = {}
    @black = {}
    @checking_piece = []
  end

  def play_game
  end

  def set_board
    create_pieces
  end

  def make_move
    puts "#{current_player.upcase}'s turn. Please select a piece to move >>"
    select_piece
    puts "Where will you move your #{selected_piece.join(' ')}? >> "
    new_position = input_position
  end

  def select_piece
    piece = gets.chomp.upcase # "piece" is a 1-character string
    until valid_piece?(piece)
      puts 'Please select a valid piece (R, N, B, Q, K or P) >> '
      piece = gets.chomp.upcase
    end
    @selected_piece << piece
    initial_position(piece)
  end

  def initial_position(piece)
    puts "Which #{piece} would you like to move? (Input its current square)>> "
    position = gets.chomp.upcase # "position" is a 2-characters string
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
<<<<<<< HEAD
<<<<<<< Updated upstream
=======
# game.white.each_pair do |key, value| 
#   value.each { |piece| p "#{key} at #{piece.square}" }
# end
# game.check?
# p game.black
>>>>>>> track_pieces
# game.board[7][4] = nil

game.board[3][3] = King.new('white', [3, 3])
<<<<<<< HEAD
game.white_king = [3, 3]
# game.board[1][1] = Knight.new('black', [1, 1])
# game.board[1][5] = Knight.new('black', [1, 5])
game.board[7][3] = Rook.new('black', [7, 3])
game.board[1][3] = Rook.new('white', [1, 3])
game.board[3][7] = Rook.new('black', [3, 7])
game.board[3][1] = Rook.new('white', [3, 1])
# game.board[3][5] = Rook.new('black', [3, 5])
game.board[0][3] = Queen.new('black', [0, 3])
game.board[5][3] = Queen.new('white', [5, 3])
game.board[3][0] = Queen.new('black', [3, 0])
game.board[3][5] = Queen.new('white', [3, 5])
game.board[0][6] = Queen.new('black', [0, 6])
# game.board[6][6] = Bishop.new('black', [6, 6])
=======
# game.make_move



game.board[3][3] = King.new('white', [3, 3])
game.board[1][5] = Knight.new('white', [1, 5])
game.board[5][4] = Knight.new('black', [5, 4])
=======
game.board[1][5] = Knight.new('white', [1, 5])
>>>>>>> track_pieces

game.board[1][1] = Queen.new('black', [1, 1])
#
game.board[6][0] = Bishop.new('black', [6, 0])
<<<<<<< HEAD
game.board[3][2] = Bishop.new('white', [3, 2])
game.board[0][5] = Bishop.new('white', [0, 5])

# game.board[7][3] = Rook.new('black', [7, 3])
game.board[5][1] = Rook.new('white', [5, 1])

game.board[2][2] = Pawn.new('white', [2, 2])
=======
game.board[4][2] = Bishop.new('white', [4, 2])
game.board[0][5] = Bishop.new('white', [0, 5])

game.board[3][0] = Rook.new('black', [3, 0])
>>>>>>> track_pieces

game.board.each do |row|
  row.each do |piece|
    if !piece.nil? && piece.color == 'white'
      game.white.has_key?(piece.class) ? game.white[piece.class] << piece : game.white[piece.class] = [piece]
    elsif !piece.nil? && piece.color == 'black'
      game.black.has_key?(piece.class) ? game.black[piece.class] << piece : game.black[piece.class] = [piece]
    end
  end
end
<<<<<<< HEAD

puts "White pieces on the board."
game.white.each_pair do |key, value|
  value.each { |piece| puts "#{key} at #{piece.square}" }
end
>>>>>>> Stashed changes
=======
>>>>>>> track_pieces

puts "White pieces on the board."
game.white.each_pair do |key, value|
  value.each { |piece| puts "#{key} at #{piece.square}" }
end

puts "\nBlack pieces on the board."
game.black.each_pair do |key, value|
  value.each { |piece| puts "#{key} at #{piece.square}" }
end

<<<<<<< HEAD
<<<<<<< Updated upstream
puts game.check? ? "#{game.current_player.capitalize} King IS in check." : "#{game.current_player.capitalize} King IS NOT in check"
puts "Checkmate? #{game.checkmate?}"
=======
if game.check?
  puts "#{game.current_player.capitalize} King IS in check."
  puts "Check given by #{game.checking_piece[0].class} at #{game.checking_piece[0].square}"
else
  puts "#{game.current_player.capitalize} King IS NOT in check"
end
# puts "Checkmate? #{game.checkmate?}"
>>>>>>> Stashed changes
=======
# if game.check?
#   puts "#{game.current_player.capitalize} King IS in check."
#   puts "Check given by #{game.checking_piece[0].class} at #{game.checking_piece[0].square}"
# else
#   puts "#{game.current_player.capitalize} King IS NOT in check"
# end
# puts "Checkmate? #{game.checkmate?}"
>>>>>>> track_pieces
# p game.white_king
# game.board.each { |row| p row }

# # scenario for blocking a check
# game.board[3][3] = King.new('white', [3, 3])
# game.white_king = [3, 3]
# game.board[1][1] = Knight.new('black', [1, 1])
# game.board[4][0] = Rook.new('black', [4, 0])
# game.board[3][2] = Rook.new('white', [3, 2])
# game.board[0][4] = Queen.new('black', [0, 4])
# game.board[4][6] = Queen.new('white', [4, 6])
# game.board[6][6] = Bishop.new('black', [6, 6])