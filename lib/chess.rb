
require_relative "/lib/pieces"
require_relative "/lib/move_validation"

class Chess

  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8) { " " } }
  end

  def play_game
  end

  def set_board
    
  end

  def create(piece_name)
  end
end
