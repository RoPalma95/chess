# frozen_string_literal: true

require 'pry'
require_relative '../lib/pieces'
require_relative '../lib/move_validation'

module Check
  def check?(king_square)
    # king = @current_player == 'white' ? @white[King][0] : @black[King][0]
    # square = king.square
    # 1. check if there are any opposing rooks or queens in the same
    # row or column as the king
    check_horizontal(king_square[0], king_square[1] - 1, king_square[1] + 1)
    check_vertical(king_square[1], king_square[0] - 1, king_square[0] + 1)
      # 2. check if there are any opposing bishops or queens in the same
      # diagonals as the king
    check_diagonals(king_square)
    # 3. check if the king can be taken by an opposing knight
    check_knights(king_square[0], king_square[1])
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
    king_square = king.square
    @board[king_square[0]][king_square[1]] = nil
    # binding.pry
    if_king_moves?(king)
    # || someone_block?(king)
  end

  def if_king_moves?(king, possible = [])
    test_square = king.square
    
    8.times do |i|
      possible.clear << test_square[0] + King::POSSIBLE_X[i]
      possible << test_square[1] + King::POSSIBLE_Y[i]

      if !out_of_bounds?(possible) && can_take?(possible)
        # binding.pry
        checks = @checking_piece.length
        check?(possible)
        next if @checking_piece.length > checks

        next if @checking_piece.any? do |piece|
                  [Queen, Rook, Bishop].include?(piece.class) ? piece.valid_move?(possible, @board) : piece.valid_move?(possible)
                end

        return false
      end
    end
    true
  end

  # def someone_block?(king)
  # end
end