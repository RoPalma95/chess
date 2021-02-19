# frozen_string_literal: true

require 'pry'
require_relative '../lib/pieces'
require_relative '../lib/move_validation'

module Check
  def check?
    king = @current_player == 'white' ? @white[King][0] : @black[King][0]
    # square = king.square
    # 1. check if there are any opposing rooks or queens in the same
    # row or column as the king
    check_horizontal(king.square[0], king.square[1] - 1, king.square[1] + 1)
    check_vertical(king.square[1], king.square[0] - 1, king.square[0] + 1)
      # 2. check if there are any opposing bishops or queens in the same
      # diagonals as the king
    check_diagonals(king.square)
    # 3. check if the king can be taken by an opposing knight
    check_knights(king.square[0], king.square[1])
    !@checking_piece.empty?
  end

  private

  def check_horizontal(row, left, right)
    until left.negative?
      if !@board[row][left].nil? && @board[row][left].color == @current_player
        break
      elsif [Rook, Queen].include?(@board[row][left].class)
        by_who?(@board[row][left])
      end
      left -= 1
    end

    until right > 7
      if !@board[row][right].nil? && @board[row][right].color == @current_player
        break
      elsif [Rook, Queen].include?(@board[row][right].class)
        by_who?(@board[row][right])
      end
      right += 1
    end
  end

  def check_vertical(col, up, down)
    until up.negative?
      if !@board[up][col].nil? && @board[up][col].color == @current_player
        break
      elsif [Rook, Queen].include?(@board[up][col].class)
        by_who?(@board[up][col])
      end
      up -= 1
    end

    until down > 7
      if !@board[down][col].nil? && @board[down][col].color == @current_player
        break
      elsif [Rook, Queen].include?(@board[down][col].class)
        by_who?(@board[down][col])
      end
      down += 1
    end
  end

  def check_diagonals(king)
    check_ltr([king[0] - 1, king[1] - 1], [king[0] + 1, king[1] + 1])
    check_rtl([king[0] - 1, king[1] + 1], [king[0] + 1, king[1] - 1])
  end

  def check_ltr(ltr_up, ltr_down)
    until ltr_up.any?(&:negative?)
      if !@board[ltr_up[0]][ltr_up[1]].nil? && @board[ltr_up[0]][ltr_up[1]].color == @current_player
        break
      elsif [Bishop, Queen].include?(@board[ltr_up[0]][ltr_up[1]].class)
        by_who?(@board[ltr_up[0]][ltr_up[1]])
      end
      ltr_up.map! { |element| element - 1 }
    end

    until ltr_down.any? { |e| e > 7 }
      if !@board[ltr_down[0]][ltr_down[1]].nil? && @board[ltr_down[0]][ltr_down[1]].color == @current_player
        break
      elsif [Bishop, Queen].include?(@board[ltr_down[0]][ltr_down[1]].class)
        by_who?(@board[ltr_down[0]][ltr_down[1]])
      end
      ltr_down.map! { |element| element + 1 }
    end
  end

  def check_rtl(rtl_up, rtl_down)
    until rtl_up[0].negative? || rtl_up[1] > 7
      if !@board[rtl_up[0]][rtl_up[1]].nil? && @board[rtl_up[0]][rtl_up[1]].color == @current_player
        break
      elsif [Bishop, Queen].include?(@board[rtl_up[0]][rtl_up[1]].class)
        by_who?(@board[rtl_up[0]][rtl_up[1]])
      end
      rtl_up = [rtl_up[0] - 1, rtl_up[1] + 1]
    end

    until rtl_down[0] > 7 || rtl_down[1].negative?
      if !@board[rtl_down[0]][rtl_down[1]].nil? && @board[rtl_down[0]][rtl_down[1]].color == @current_player
        break
      elsif [Bishop, Queen].include?(@board[rtl_down[0]][rtl_down[1]].class)
        by_who?(@board[rtl_down[0]][rtl_down[1]])
      end
      rtl_down = [rtl_down[0] + 1, rtl_down[1] - 1]
    end
  end

  def check_knights(row, col, possible = [])
    8.times do |i|
      possible.clear << row + Knight::POSSIBLE_X[i]
      possible << col + Knight::POSSIBLE_Y[i]
      next if possible.any?(&:negative?)

      if @board[possible[0]][possible[1]].class == Knight && @board[possible[0]][possible[1]].color != @current_player
        by_who?(@board[possible[0]][possible[1]])
      end
    end

  end

  def by_who?(piece)
    @checking_piece << piece unless @checking_piece.include?(piece)
  end
end

module Mate
  def checkmate?
    king = @current_player == 'white' ? @white[King][0] : @black[King][0]
    @board[king.square[0]][king.square[1]] = nil

    mate = if_king_moves?(king) && someone_block?(king)
    
    @board[king.square[0]][king.square[1]] = king
    mate
  end

  def if_king_moves?(king, possible = [])
    test_square = king.square
    
    8.times do |i|
      possible.clear << test_square[0] + King::POSSIBLE_X[i]
      possible << test_square[1] + King::POSSIBLE_Y[i]

      if !out_of_bounds?(possible) && can_take?(possible)
        checks = @checking_piece.length
        check?
        next if @checking_piece.length > checks

        next if @checking_piece.any? do |piece|
                  [Queen, Rook, Bishop].include?(piece.class) ? piece.valid_move?(possible, @board) : piece.valid_move?(possible)
                end

        return false
      end
    end
    true
  end

  def someone_block?(king)
    own_pieces = king.color == 'white' ? @white : @black
    pieces_to_block = may_be_blocked(king).compact

    pieces_to_block.each do |piece|
      location = piece.square[1] <=> king.square[1] # location => -1: left; 0: same col; 1: right
      return block_horizontal?(king, piece, own_pieces, location) if location.nonzero? && piece.class != Bishop

      location = piece.square[0] <=> king.square[0] # location => -1: above; 0: same row; 1: below
      return block_vertical?(king, piece, own_pieces, location) if location.nonzero? && piece.class != Bishop

      return block_diagonal?(king, piece, own_pieces, location)
    end
  end

  def may_be_blocked(king)
    @checking_piece.map do |piece| 
      if [Queen, Rook, Bishop].include?(piece.class)
        direct_LoS?(king, piece) || diagonal_LoS?(king, piece) ? piece : next
      end
    end
  end

  private 

  def ltr(base, a = [], r = 0, c = 0)
    row, col = base
    (row - col).negative? ? c = col - row : r = row - col
  
    until [r, c].any? { |e| e > 7 }
      a << [r, c]
      r += 1
      c += 1
    end
    a
  end
  
  def rtl(base, a = [])
    row, col = base
    8.times do |i|
      8.times do |j|
        a << [i, j] if i + j == row + col
      end
    end
    a
  end

  def direct_LoS?(king, piece) # LOS == Line of Sight
    # in the same row? || in the same column?
    king.square[0] == piece.square[0] || king.square[1] == piece.square[1]
  end

  def diagonal_LoS?(king, piece)
    ltr = ltr(king.square)
    rtl = rtl(king.square)

    ltr.include?(piece.square) || rtl.include?(piece.square)
  end
  
  def block_vertical?(king, piece, player_pieces, location)
    p_row, p_col = piece.square
    k_row, k_col = king.square
  
    if location.negative?
      row = k_row - 1
      until row < p_row
        player_pieces.each_pair do |p_class, pieces|
          next if p_class == King

          return false if pieces.any? do |piece|
                            [Queen, Rook, Bishop].include?(p_class) ? piece.valid_move?([row, k_col], @board) : piece.valid_move([row, k_col])
                          end

        end
        row -= 1
      end
    else
      row = k_row + 1
      until row > p_row
        player_pieces.each_pair do |p_class, pieces|
          next if p_class == King

          return false if pieces.any? do |piece|
                            [Queen, Rook, Bishop].include?(p_class) ? piece.valid_move?([row, k_col], @board) : piece.valid_move([row, k_col])
                          end

        end
        row += 1
      end
    end
    true
  end

  def block_horizontal?(king, piece, player_pieces, location)
    p_row, p_col = piece.square
    k_row, k_col = king.square
  
    if location.negative?
      col = k_col - 1
      until col < p_col
        player_pieces.each_pair do |p_class, pieces|
          next if p_class == King

          return false if pieces.any? do |piece|
                            [Queen, Rook, Bishop].include?(p_class) ? piece.valid_move?([k_row, col], @board) : piece.valid_move([k_row, col])
                          end

        end
        col -= 1
      end
    else
      col = k_col + 1
      until col > p_col
        player_pieces.each_pair do |p_class, pieces|
          next if p_class == King

          return false if pieces.any? do |piece|
                            [Queen, Rook, Bishop].include?(p_class) ? piece.valid_move?([k_row, col], @board) : piece.valid_move([k_row, col])
                          end

        end
        col += 1
      end
    end
    true
  end

  def block_diagonal?(king, piece, player_pieces, location)
    p_row, p_col = piece.square
    k_row, k_col = king.square

    ltr = ltr(king.square)
    rtl = rtl(king.square)

    if ltr.include?(piece.square)
      if location.negative?
        row, col = [k_row - 1, k_col - 1]
        until [row, col] == [p_row - 1, p_col - 1]
          player_pieces.each_pair do |p_class, pieces|
            next if p_class == King

            return false if pieces.any? do |piece|
                              [Queen, Rook, Bishop].include?(p_class) ? piece.valid_move?([row, col], @board) : piece.valid_move?([row, col])
                            end
          end
          row, col = [row - 1, col - 1]
        end
      else # location == 1
        row, col = [k_row + 1, k_col + 1]
        until [row, col] == [p_row + 1, p_col + 1]
          player_pieces.each_pair do |p_class, pieces|
            next if p_class == King

            return false if pieces.any? do |piece|
                              [Queen, Rook, Bishop].include?(p_class) ? piece.valid_move?([row, col], @board) : piece.valid_move?([row, col])
                            end
          end
          row, col = [row + 1, col + 1]
        end
      end
    else # piece is included in the kings rtl
      if location.negative?
        row, col = [k_row - 1, k_col + 1]
        until [row, col] == [p_row - 1, p_col + 1]
          player_pieces.each_pair do |p_class, pieces|
            next if p_class == King

            return false if pieces.any? do |piece|
                              [Queen, Rook, Bishop].include?(p_class) ? piece.valid_move?([row, col], @board) : piece.valid_move?([row, col])
                            end
          end
          row, col = [row - 1, col + 1]
        end
      else # location == 1
        row, col = [k_row + 1, k_col - 1]
        until [row, col] == [p_row + 1, p_col - 1]
          player_pieces.each_pair do |p_class, pieces|
            next if p_class == King

            return false if pieces.any? do |piece|
                              [Queen, Rook, Bishop].include?(p_class) ? piece.valid_move?([row, col], @board) : piece.valid_move?([row, col])
                            end
          end
          row, col = [row + 1, col - 1]
        end
      end
    end
    true
  end
end
