
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

  def valid_move?(dest)
    current = @square.split('').map { |element| element.to_i }

    dest[0] == current[0] || dest[1] == current[1]
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

  POSSIBLE_X = [-1, 1, 0, 0, -1, 1, -1, 1]
  POSSIBLE_Y = [0, 0, -1, 1, 1, 1, -1, -1]

  def initialize(color, square)
    super
  end

  def valid_move?(dest, possible = [])
    current =  @square.split('').map { |element| element.to_i }
    POSSIBLE_X.length.times do |i|
      possible << current[0] + POSSIBLE_X[i]
      possible << current[1] + POSSIBLE_Y[i]
      return true if possible == dest

      possible.clear
    end
    false
  end
end

class Pawn < Rook
  def initialize(color, square)
    super
  end
end

# rook = Rook.new('white', '43')
# p rook.valid_move?([6, 4])

king = King.new('white', '44')
p king.valid_move?([6, 4])