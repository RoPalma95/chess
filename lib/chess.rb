
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
    # intro message
    # set_board
    make_move
    @board.each do |row|
      p row
    end
  end

  def set_board
    create_pieces
    # draw_board
  end

  def make_move
    puts "#{current_player.upcase}'s turn. Please select a piece to move >>"
    select_piece
    puts "Where will you move your #{selected_piece.join(' ')}? >> "
    move = input_position
    update_board(translate(move))
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

  def input_position # returns 'position' in Chess Notation
    position = gets.chomp.upcase
    until valid_end_pos?(position)
      puts "Please select a valid destination >> "
      position = gets.chomp.upcase
    end
    position
  end

  def update_board(new_pos)
    current_space = translate(selected_piece[1])
    piece = @board[current_space[0]][current_space[1]].dup
    @board[current_space[0]][current_space[1]] = nil
    piece = update_piece(piece, new_pos)
    @board[new_pos[0]][new_pos[1]] = piece
  end

  def update_piece(piece, new_pos)
    piece.square = new_pos
    piece.moved = true if piece.moved == false
    if piece.class == Queen
      update_piece(piece.helper_B, new_pos)
      update_piece(piece.helper_R, new_pos)
    end
    piece
  end

  def change_player
    @current_player = current_player == 'white' ? 'black' : 'white'
    @selected_piece.clear
  end
end

game = Chess.new

game.board[5][1] = Knight.new('white', [5, 1])
game.board[1][2] = Queen.new('white', [1, 2])
game.board[3][3] = Pawn.new('black', [3, 3])

game.board.each do |row|
  row.each do |square|
    next if square.nil?

    if square.color == 'white'
      game.white.has_key?(square.class) ? game.white[square.class] << square : game.white[square.class] = [square]
    else
      game.black.has_key?(square.class) ? game.black[square.class] << square : game.black[square.class] = [square]
    end
  end
end

# p game.white
# p game.black
game.play_game
