
require_relative '../lib/pieces'
require_relative '../lib/create_pieces'
require_relative '../lib/move_validation'

class Chess
  include CreatePieces
  include MoveValidation

  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8) { " " } }
    @current_player = 'white'
  end

  def play_game
  end

  def set_board
    create_pieces
  end
end

game = Chess.new
game.set_board
game.board.each do |row|
  p row
end
