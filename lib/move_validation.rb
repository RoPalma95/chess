require 'pry'

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
    actual_piece = @board[position[0]][position[1]]
    piece = PIECES[piece]
    actual_piece.class.to_s == piece && actual_piece.color == current_player
  end

  def valid_end_pos?(position)
    # 1. checks if pos is out of bounds
    return false if out_of_bounds?(position)

    end_position = translate(position)
    current_pos = translate(@selected_piece[1])
    piece = @board[current_pos[0]][current_pos[1]]

    # 2. passes the position to the piece to check if it's a valid move
    if %w[R B Q].include?(@selected_piece[0])
      return false unless piece.valid_move?(end_position, @board)
    else
      return false unless piece.valid_move?(end_position)
    end

    # 3. checks if the destination square can be taken
    return false unless can_take?(end_position)

    # 4. checks the status of the king, asks for new input if king is in check
    # if all four tests pass, then end position is valid
  end

  def check?
    
  end

  private

  def translate(position)
    # translates CHESS NOTATION into Ruby indexes [row, col]
    position = position.reverse.split('')
    position[0] = (8 - position[0].to_i) 
    position[1] = COL_LETTERS.index(position[1])
    position
  end

  def can_take?(dest)
    dest_content = @board[dest[0]][dest[1]]
    return (dest_content.nil? || dest_content.color != @current_player) ? true : false
  end
end