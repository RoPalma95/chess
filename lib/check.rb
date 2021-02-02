
module CheckMate

  def check?
    king = @current_player == 'white' ? @white_king : @black_king
    king_row, king_col = king
    # 1. check if there are any opposing rooks or queens in the same 
    # row or column as the king
    check_horizontal(king_row, king_col)
    # 2. check if there are any opposing bishops or queens in the same
    # diagonals as the king
    # safe_bishops(king_row, king_col)
    # 3. check if the king can be taken by an opposing knight
    # safe_kingts(king_row, king_col)
  end

  private

  def check_horizontal(row, col)
    temp = col - 1
    until temp.negative?
      if [Rook, Queen].include?(@board[row][temp].class)
        return true unless @board[row][temp].color == @current_player
      end
      temp -= 1
    end

    temp = col + 1
    until temp > 7
      if [Rook, Queen].include?(@board[row][temp].class)
        return true unless @board[row][temp].color == @current_player
      end
      temp += 1
    end
    false
  end
end