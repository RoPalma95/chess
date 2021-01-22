
require_relative '../lib/pieces'

module CreatePieces

  # POSITIONS = %w[Rook Knight Bishop Queen King Bishop Knight Rook].freeze

  def create_pieces
    create_pawns
    create_rooks
    create_knights
    create_bishops
    create_queens
    create_kings
  end

  def create_pawns
    @board[6] = @board[6].each_with_index.map do |square, square_i|
      Pawn.new('white', "6#{square_i}")
    end

    @board[1] = @board[1].each_with_index.map do |square, square_i|
      Pawn.new('black', "1#{square_i}")
    end
  end

  def create_rooks
    @board[7][0] = Rook.new('white', '70')
    @board[7][7] = Rook.new('white', '77')

    @board[0][0] = Rook.new('black', '00')
    @board[0][7] = Rook.new('black', '07')
  end

  def create_knights
    @board[7][1] = Knight.new('white', '71')
    @board[7][6] = Knight.new('white', '76')

    @board[0][1] = Knight.new('black', '01')
    @board[0][6] = Knight.new('black', '06')
  end

  def create_bishops
    @board[7][2] = Bishop.new('white', '72')
    @board[7][5] = Bishop.new('white', '75')

    @board[0][2] = Bishop.new('black', '02')
    @board[0][5] = Bishop.new('black', '05')
  end

  def create_queens
    @board[7][3] = Queen.new('white', '73')
    @board[0][3] = Queen.new('black', '03')
  end

  def create_kings
    @board[7][4] = King.new('white', '74')
    @board[0][4] = King.new('black', '04')
  end

  # def create_first_row
  #   POSITIONS.each_with_index do |piece, i|
  #     @board[0][i] = piece.new('white', "0#{i}")
  #   end
  # end
end