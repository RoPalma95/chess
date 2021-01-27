
require 'pry'

class Rook  
  attr_reader :color, :square, :moved

  def initialize(color, square)
    #square is a 2-element array [row, col]
    @color = color
    @square = square
    @moved = false
  end

  def valid_move?(dest, board)
    valid_square?(dest) && empty_path(dest, board)
  end

  def valid_square?(dest)
    dest[0] == @square[0] || dest[1] == @square[1]
  end

  def empty_path?(dest, board)
    dest_row, dest_col = dest
    current_row, current_col = @square
    if dest_col == current_col # rook moves vertically
      vertical_path(current_row, dest_row, current_col, board)
    else # rook moves horizontally
      horizontal_path(current_col, dest_col, current_row, board)
    end
  end

  private

  def vertical_path(row, dest_row, current_col, board)
    until row == dest_row
      return false unless board[row][current_col].empty?

      row = row > dest_row ? row - 1 : row + 1
    end
    true
  end

  def horizontal_path(col, dest_col, current_row, board)
    until col == dest_col
      return false unless board[current_row][col].empty?

      col = col > dest_col ? col - 1 : col + 1
    end
    true
  end
end

class Knight < Rook

  POSSIBLE_X = [2, 2, -2, -2, 1, 1, -1, -1].freeze
  POSSIBLE_Y = [-1, 1, 1, -1, 2, -2, 2, -2].freeze

  def initialize(color, square)
    super
  end

  def valid_move?(dest, possible = [])
    current = @square.dup
    possible.clear

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
    current = @square.dup
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

# be careful to change the helper pieces' @square when the queen moves
class Queen < Rook
  def initialize(color, square)
    super
    @helper_R = Rook.new(color, square)
    @helper_B = Bishop.new(color, square)
  end

  def valid_move?(dest)
    @helper_R.valid_move?(dest) || @helper_B.valid_move?(dest)
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

  def valid_move?(dest*)
    current = @square.dup

    color == 'white' ? white_move(dest, current) : black_move(dest, current)
  end

  private

  def white_move(dest, current)
    if moved && dest[1] == current[1]
      dest[0] == current[0] - 1
    elsif !moved && dest[1] == current[1]
      dest[0] == current[0] - 2 || dest[0] == current[0] - 1
    else
      false
    end
  end

  def black_move(dest, current)
    if moved && dest[1] == current[1]
      dest[0] == current[0] + 1
    elsif !moved && dest[1] == current[1]
      dest[0] == current[0] + 2 || dest[0] == current[0] + 1
    else
      false
    end
  end
end

# rook = Rook.new('white', [4, 3])
# p rook.valid_move?([4, 7])

# king = King.new('white', [4, 4])
# p king.valid_move?([3, 3])

# knight = Knight.new('white', [3, 4])
# p knight.valid_move?([1, 5])

# bishop = Bishop.new('white', [3, 4])
# p bishop.valid_move?([5, 6])

# queen = Queen.new('white', [0, 0])
# 8.times do |i|
#   8.times do |j|
#     puts "[#{i}, #{j}] is valid" if queen.valid_move?([i, j])
#   end
# end

# pawn = Pawn.new('black', [1, 4])
# p pawn.valid_move?([2, 4])