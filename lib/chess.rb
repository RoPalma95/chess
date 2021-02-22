
require_relative '../lib/pieces'
require_relative '../lib/create_pieces'
require_relative '../lib/move_validation'
require_relative '../lib/checkmate'
require_relative '../lib/interface'
require_relative '../lib/save_game'

class Chess
  include CreatePieces, MoveValidation, Check, Mate
  include Interface, SaveGame

  attr_reader :board, :current_player, :selected_piece, :white, :black, :checking_piece, :win
  attr_writer :board, :white, :black, :win

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @current_player = 'white'
    @selected_piece = []
    @white = {}
    @black = {}
    @checking_piece = []
  end

  def play_game
    introduction
    create_pieces
    make_move
    change_player
    loop do
      if check?
        if checkmate?
          break
        end
        puts "#{current_player} is in Check!"
      end
      make_move
      change_player
    end
    puts current_player == 'white' ? 'Checkmate! White wins!' : 'Checkmate! Black wins!'
    sleep 1
  end

  def make_move
    print "#{current_player.upcase}'s turn. Please select a piece to move >> "
    select_piece
    move = translate(input_position)
    until legal?(move)
      puts "Your King is still in check."
      print "Please make a different move. Select a piece to move >> "
      @selected_piece.clear
      select_piece
      move = translate(input_position)
    end
    update_board(move)
  end

  def select_piece
    piece = gets.chomp.upcase # "piece" is a 1-character string
    until valid_piece?(piece)
      print 'Please select a valid piece (R, N, B, Q, K or P) >> '
      piece = gets.chomp.upcase
    end
    @selected_piece << piece
    initial_position(piece)
  end

  def initial_position(piece)
    print "Which #{piece} would you like to move? (Input its current square)>> "
    position = gets.chomp.upcase # "position" is a 2-characters string
    until valid_init_pos?(piece, position)
      print "Please select a square that contains a #{current_player} #{piece}>> "
      position = gets.chomp.upcase
    end
    @selected_piece << position
  end

  def input_position # returns 'position' in Chess Notation
    print "Where will you move your #{selected_piece.join(' ')}? >> "
    position = gets.chomp.upcase
    until valid_end_pos?(position)
      print "Please select a valid destination >> "
      position = gets.chomp.upcase
    end
    position
  end

  def update_board(new_pos)
    current_space = translate(selected_piece[1])
    
    piece = @board[current_space[0]][current_space[1]].dup
    @board[current_space[0]][current_space[1]] = nil
    
    new_piece = update_piece(piece.dup, new_pos)
    @board[new_pos[0]][new_pos[1]] = new_piece

    update_player_hash(piece, new_piece)
    draw_board
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

  def update_player_hash(piece, new_piece)
    player = current_player == 'white' ? @white : @black

    player[piece.class].each do |value|
      if value.square == piece.square
        player[piece.class].delete(value)
        player[piece.class] << new_piece
      end
    end
  end

  def change_player
    @current_player = current_player == 'white' ? 'black' : 'white'
    @selected_piece.clear
  end
end

game = Chess.new
game.play_game

# game.board[5][1] = Knight.new('black', [5, 1])
# game.board[1][2] = Queen.new('black', [1, 2])
# game.board[3][3] = Pawn.new('white', [3, 3])
# game.board[2][4] = Pawn.new('black', [2, 4])
# game.board[2][2] = Pawn.new('black', [2, 2])
# game.board[2][3] = Pawn.new('black', [2, 3])
# game.board[4][7] = King.new('black', [4, 7])
# game.board[0][0] = Bishop.new('black', [0, 0])
# game.board[7][0] = Rook.new('white', [7, 0])
# game.board[7][7] = King.new('white', [7, 7])


# game.board.each do |row|
#   row.each do |square|
#     next if square.nil?

#     if square.color == 'white'
#       game.white.has_key?(square.class) ? game.white[square.class] << square : game.white[square.class] = [square]
#     else
#       game.black.has_key?(square.class) ? game.black[square.class] << square : game.black[square.class] = [square]
#     end
#   end
# end

# game.draw_board
# game.make_move
# if game.check?
#   puts "Check given by #{game.checking_piece[0].class} at #{game.checking_piece[0].square}"
# else
#   puts "Not in check."
# end

# game.make_move
