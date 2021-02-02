# frozen_string_literal: true

module CheckMate
  def check?
    king = @current_player == 'white' ? @white_king : @black_king
    # 1. check if there are any opposing rooks or queens in the same
    # row or column as the king
    check_horizontal(king[0], king[1] - 1, king[1] + 1) ||
    check_vertical(king[1], king[0] - 1, king[0] + 1) ||
    # 2. check if there are any opposing bishops or queens in the same
    # diagonals as the king
    check_diagonals(king)
    # 3. check if the king can be taken by an opposing knight
    # safe_kingts(king_row, king_col)
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
    check_ltr([king[0] - 1, king[1] - 1], [king[0] + 1, king[1] + 1])
  end

  def check_ltr(ltr_up, ltr_down)
    until ltr_up.any? { |e| e.negative? }
      return true if [Bishop, Queen].include?(@board[ltr_up[0]][ltr_up[1]].class) && @board[ltr_up[0]][ltr_up[1]].color != @current_player

      ltr_up.map! { |element| element - 1}
    end

    until ltr_down.any? { |e| e > 7 }
      return true if [Bishop, Queen].include?(@board[ltr_down[0]][ltr_down[1]].class) && @board[ltr_down[0]][ltr_down[1]].color != @current_player

      ltr_down.map! { |element| element + 1}
    end
  end
end
