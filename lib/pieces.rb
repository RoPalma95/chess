
require_relative '../lib/move_validation'
require 'pry'

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
end

class Knight < Rook

  POSSIBLE_X = [2, 2, -2, -2, 1, 1, -1, -1].freeze
  POSSIBLE_Y = [-1, 1, 1, -1, 2, -2, 2, -2].freeze

  def initialize(color, square)
    super
  end

  def valid_move?(dest, possible = [])
    current = @square.split('').map { |element| element.to_i }
    8.times do |i|
      possible << current[0] + self.class::POSSIBLE_X[i]
      possible << current[1] + self.class::POSSIBLE_Y[i]
      return true if possible == dest

      possible.clear
    end
    false
  end
end

class Bishop < Rook
  def initialize(color, square)
    super
  end

  def valid_move?(dest)
    current = @square.split('').map { |element| element.to_i }
    ltr_diagonal(dest, current) || rtl_diagonal(dest, current)
  end

  private

  def ltr_diagonal(dest, current, possible = current.dup)
    until possible[0].negative? || possible[1].negative?
      possible[0] = possible[0] - 1
      possible[1] = possible[1] - 1
      return true if possible == dest
    end

    possible = current.dup

    until possible[0] > 7 || possible[1] > 7
      possible[0] = possible[0] + 1
      possible[1] = possible[1] + 1
      return true if possible == dest
    end
    false
  end

  def rtl_diagonal(dest, current, possible = current.dup)
    until possible[0].negative? || possible[1] > 7
      possible[0] = possible[0] - 1
      possible[1] = possible[1] + 1
      return true if possible == dest
    end

    possible = current.dup

    until possible[0] > 7 || possible[1].negative?
      possible[0] = possible[0] + 1
      possible[1] = possible[1] - 1
      return true if possible == dest
    end
    false
  end
end

class Queen < Rook
  def initialize(color, square)
    super
  end
end

class King < Knight

  POSSIBLE_X = [-1, 1, 0, 0, -1, 1, -1, 1].freeze
  POSSIBLE_Y = [0, 0, -1, 1, 1, 1, -1, -1].freeze

  def initialize(color, square)
    super
  end
end

class Pawn < Rook
  def initialize(color, square)
    super
  end
end

# rook = Rook.new('white', '43')
# p rook.valid_move?([6, 4])

# king = King.new('white', '44')
# p king.valid_move?([2, 4])

# knight = Knight.new('white', '34')
# p knight.valid_move?([4, 4])

# bishop = Bishop.new('white', '34')
# p bishop.valid_move?([7, 7])