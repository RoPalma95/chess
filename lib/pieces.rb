
require 'pry'

class Rook  
  attr_reader :color
  attr_accessor :square, :moved

  def initialize(color, square)
    #square is a 2-element array [row, col]
    @color = color
    @square = square
    @moved = false
  end

  def valid_move?(dest, board)
    valid_square?(dest) && empty_path?(dest, board)
  end

  def valid_square?(dest)
    dest[0] == @square[0] || dest[1] == @square[1]
  end

  def empty_path?(dest, board)
    return false if dest == @square

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
    row = row > dest_row ? row - 1 : row + 1
    until row == dest_row
      return false unless board[row][current_col].nil?

      row = row > dest_row ? row - 1 : row + 1
    end
    true
  end

  def horizontal_path(col, dest_col, current_row, board)
    col = col > dest_col ? col - 1 : col + 1
    until col == dest_col
      return false unless board[current_row][col].nil?

      col = col > dest_col ? col - 1 : col + 1
    end
    true
  end
end

class Knight < Rook

  POSSIBLE_X = [2, 2, -2, -2, 1, 1, -1, -1].freeze
  POSSIBLE_Y = [-1, 1, 1, -1, 2, -2, 2, -2].freeze

  def valid_move?(dest, possible = [])
    current = @square.dup

    8.times do |i|
      possible.clear << current[0] + self.class::POSSIBLE_X[i]
      possible << current[1] + self.class::POSSIBLE_Y[i]
      return true if possible == dest

    end
    false
  end
end

class Bishop < Rook

  def valid_move?(dest, board)
    valid_square?(dest) && empty_path?(dest, board)
  end

  def valid_square?(dest)
    current = @square.dup
    ltr_diagonal(dest, current) || rtl_diagonal(dest, current)
  end

  def empty_path?(dest, board)
    dest_row, dest_col = dest
    current_row, current_col = @square
    if dest_row < current_row && dest_col < current_col # bishop moves up ltr
      ltr_up(current_row, current_col, dest_row, board)
    elsif dest_row > current_row && dest_col > current_col # bishop moves down ltr
      ltr_down(current_row, current_col, dest_row, board)
    elsif dest_row < current_row && dest_col > current_col # bishop moves up rtl
      rtl_up(current_row, current_col, dest_row, board)
    elsif dest_row > current_row && dest_col < current_col # bishop moves down rtl
      rtl_down(current_row, current_col, dest_row, board)
    end
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

  def ltr_up(row, col, dest_row, board)
    row -= 1
    col -= 1
    until row == dest_row
      return false unless board[row][col].nil?

      row -= 1
      col -= 1
    end
    true
  end

  def ltr_down(row, col, dest_row, board)
    row += 1
    col += 1
    until row == dest_row
      return false unless board[row][col].nil?

      row += 1
      col += 1
    end
    true
  end

  def rtl_up(row, col, dest_row, board)
    row -= 1
    col += 1
    until row == dest_row
      return false unless board[row][col].nil?

      row -= 1
      col += 1
    end
    true
  end

  def rtl_down(row, col, dest_row, board)
    row += 1
    col -= 1
    until row == dest_row
      return false unless board[row][col].nil?

      row += 1
      col -= 1
    end
    true
  end
end

# be careful to change the helper pieces' @square when the queen moves
class Queen < Rook
  attr_accessor :helper_B, :helper_R

  def initialize(color, square)
    super
    @helper_R = Rook.new(color, square)
    @helper_B = Bishop.new(color, square)
  end

  def valid_move?(dest, board)
    @helper_R.valid_move?(dest, board) || @helper_B.valid_move?(dest, board)
  end
end

class King < Knight

  POSSIBLE_X = [-1, 1, 0, 0, -1, 1, -1, 1].freeze
  POSSIBLE_Y = [0, 0, -1, 1, 1, 1, -1, -1].freeze
end

class Pawn < Rook

  def valid_move?(dest, board)
    current = @square.dup
    # binding.pry
    # is it moving in a straight line? (same column)
    if current[1] == dest[1] && board[dest[0]][dest[1]].nil?
      color == 'white' ? straight_movement(dest, current, board, -1) : straight_movement(dest, current, board, 1)
    elsif current[0] != dest[0] && current[1] != dest[1] # is it moving diagonally
      color == 'white' ? diagonal_movement(dest, current, board, -1) : diagonal_movement(dest, current, board, 1)
    else
      false
    end
  end

  private

  def straight_movement(dest, current, board, direction)
    if moved
      dest[0] == current[0] + direction
    elsif board[current[0] + direction][current[1]].nil?
      dest[0] == current[0] + (2 * direction) || dest[0] == current[0] + direction
    else
      false
    end
  end

  def diagonal_movement(dest, current, board, direction)
    if board[dest[0]][dest[1]].nil?
      false
    elsif board[dest[0]][dest[1]].color != color
      dest[0] == current[0] + direction && (dest[1] == current[1] + direction || dest[1] == current[1] - direction)
    end
  end
end
