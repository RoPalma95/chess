
module MoveValidation

  # VALID_PIECES = %w[R N B Q K P].freeze
  COL_LETTERS = %w[A B C D E F G H].freeze
  PIECES = {
    'R' => 'Rook',
    'N' => 'Knight',
    'B' => 'Bishop',
    'Q' => 'Queen',
    'K' => 'King',
    'P' => 'Pawn'
  }.freeze

  def valid_piece?(piece)
    PIECES.has_key?(piece)
  end

  def out_of_bounds?(position)
    # position is in CHESS NOTATION
    !(COL_LETTERS.include?(position[0]) && position[1].to_i.between?(1, 8))
  end

  def valid_init_pos?(piece, position)
    return false if out_of_bounds?(position)

    position = translate(position)
    actual_piece = @board[position[0].to_i][position[1].to_i]
    piece = PIECES[piece]
    actual_piece.class.to_s == piece && actual_piece.color == current_player
  end

  private

  def translate(position)
    # translates CHESS NOTATION to Ruby indexes
    position = position.reverse.split('')
    position[0] = (8 - position[0].to_i).to_s 
    position[1] = COL_LETTERS.index(position[1]).to_s
    position
  end
end