
module MoveValidation

  VALID_PIECES = %w[R N B Q K P].freeze
  COL_LETTERS = %w[A B C D E F G H].freeze

  def valid_piece?(piece)
    VALID_PIECES.include?(piece)
  end

  def out_of_bounds?(position)
    # position is in CHESS NOTATION
    !(COL_LETTERS.include?(position[0]) && position[1].to_i.between?(1, 8))
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