
require_relative '../lib/move_validation'

class Rook
  include MoveValidation
  
  attr_reader :color, :square, :moved

  def initialize(color, square)
    #square is a 2-digit string ("rowcol")
    @color = color
    @square = square
    @moved = false
  end

  def take
  end
end

class Knight < Rook
  def initialize(color, square)
    super
  end
end

class Bishop < Rook
  def initialize(color, square)
    super
  end
end

class Queen < Rook
  def initialize(color, square)
    super
  end
end

class King < Rook
  def initialize(color, square)
    super
  end

  def valid_move?(dest)
    # dest is a 2-element array (end = [row, col])
    current = @square.split('').map { |element| element.to_i }
    p current, dest
    return fwd_bkwd(current, dest) || left_right(current, dest) || diagonal(current, dest)
  end

  private

  def fwd_bkwd(start, finish)
    (finish[0] == start[0] + 1 || finish[0] == start[0] - 1) && finish[1] == start[1]
  end

  def left_right(start, finish)
    finish[0] == start[0] && (finish[1] == start[1] + 1 || finish[1] == start[1] - 1)
  end

  def diagonal(start, finish)
    (finish[0] == start[0] + 1 && finish[1] == start[1] + 1) ||
    (finish[0] == start[0] + 1 && finish[1] == start[1] - 1) ||
    (finish[0] == start[0] - 1 && finish[1] == start[1] - 1) ||
    (finish[0] == start[0] - 1 && finish[1] == start[1] + 1)
  end
end

class Pawn < Rook
  def initialize(color, square)
    super
  end
end

king = King.new('white', '74')
p king.valid_move?([5, 2])

