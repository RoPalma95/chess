# frozen_string_literal: true

require 'pry'
require_relative '../lib/pieces'
require_relative '../lib/move_validation'

module Check

  TEST_X = [-2, -2, 2, 2].freeze
  TEST_Y = [-1, 1, -1, 1].freeze

  def check?
    king = @current_player == 'white' ? @white_king : @black_king
    # 1. check if there are any opposing rooks or queens in the same
    # row or column as the king
    check_horizontal(king[0], king[1] - 1, king[1] + 1) ||
      check_vertical(king[1], king[0] - 1, king[0] + 1) ||
      # 2. check if there are any opposing bishops or queens in the same
      # diagonals as the king
      check_diagonals(king) ||
    # 3. check if the king can be taken by an opposing knight
      check_knights(king[0], king[1])
  end

  private

  def check_horizontal(row, left, right)
    # binding.pry
    until left.negative?
      return true if [Rook, Queen].include?(@board[row][left].class) && @board[row][left].color != @current_player

      left -= 1
    end

    until right > 7
      return true if [Rook, Queen].include?(@board[row][right].class) && @board[row][right].color != @current_player

      right += 1
    end
    false
  end

  def check_vertical(col, up, down)
    until up.negative?
      return true if [Rook, Queen].include?(@board[up][col].class) && @board[up][col].color != @current_player

      up -= 1
    end

    until down > 7
      return true if [Rook, Queen].include?(@board[down][col].class) && @board[down][col].color != @current_player

      down += 1
    end
  end

  def check_diagonals(king)
    check_ltr([king[0] - 1, king[1] - 1], [king[0] + 1, king[1] + 1]) ||
      check_rtl([king[0] - 1, king[1] + 1], [king[0] + 1, king[1] - 1])
  end

  def check_ltr(ltr_up, ltr_down)
    until ltr_up.any?(&:negative?)
      if [Bishop, Queen].include?(@board[ltr_up[0]][ltr_up[1]].class) && @board[ltr_up[0]][ltr_up[1]].color != @current_player
        return true
      end

      ltr_up.map! { |element| element - 1 }
    end

    until ltr_down.any? { |e| e > 7 }
      if [Bishop, Queen].include?(@board[ltr_down[0]][ltr_down[1]].class) && @board[ltr_down[0]][ltr_down[1]].color != @current_player
        return true
      end

      ltr_down.map! { |element| element + 1 }
    end
  end

  def check_rtl(rtl_up, rtl_down)
    until rtl_up[0].negative? || rtl_up[1] > 7
      if [Bishop, Queen].include?(@board[rtl_up[0]][rtl_up[1]].class) && @board[rtl_up[0]][rtl_up[1]].color != @current_player
        return true
      end

      rtl_up = [rtl_up[0] - 1, rtl_up[1] + 1]
    end

    until rtl_down[0] > 7 || rtl_down[1].negative?
      if [Bishop, Queen].include?(@board[rtl_down[0]][rtl_down[1]].class) && @board[rtl_down[0]][rtl_down[1]].color != @current_player
        return true
      end

      rtl_down = [rtl_down[0] + 1, rtl_down[1] - 1]
    end
  end

  def check_knights(row, col, possible = [])
    4.times do |i|
      possible.clear
      possible << row + TEST_X[i]
      possible << col + TEST_Y[i]
      next if possible.any?(&:negative?)

      return true if @board[possible[0]][possible[1]].class == Knight && @board[possible[0]][possible[1]].color != @current_player
    end
    false
  end
end

module Mate
  include MoveValidation

  def checkmate?
    king_square = @current_player == 'white' ? @white_king : @black_king
    king = @board[king_square[0]][king_square[1]]
    @board[king_square[0]][king_square[1]] = nil

    if_king_moves?(king)
      # can_king_take?(king) || can_someone_block?(king)
  end

  private

  def if_king_moves?(king, possible = [@white_king, @black_king])
    test_square = king.square
    k = king.color == 'white' ? 0 : 1

    8.times do |i|
      possible[k].clear << test_square[0] + King::POSSIBLE_X[i]
      possible[k] << test_square[1] + King::POSSIBLE_Y[i]
      
      if !out_of_bounds?(possible[k]) && king.valid_move?(possible[k])
        unless check?
          possible[k].clear << king.square[0] << king.square[1]
          return false
        end
      end
    end
    possible[k].clear << king.square[0] << king.square[1]
    true
  end
end