
require_relative '../lib/pieces'

module CreatePieces
  def create_pawns
    # populate pawns rows
    @board[6] = @board[6].each_with_index.map do |square, square_i|
      Pawn.new('white', "6#{square_i}")
    end

    @board[1] = @board[1].each_with_index.map do |square, square_i|
      Pawn.new('black', "1#{square_i}")
    end
  end
end