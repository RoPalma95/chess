
require 'pry'

module MoveValidation 
  COL_LETTERS = %w[A B C D E F G H].freeze
  PIECES = {
    'R' => Rook,
    'N' => Knight,
    'B' => Bishop,
    'Q' => Queen,
    'K' => King,
    'P' => Pawn
  }.freeze

  def valid_piece?(piece)
    PIECES.has_key?(piece)
  end

  def out_of_bounds?(position)
    if position[0].class == String # 'position' is in CHESS NOTATION
      return !(COL_LETTERS.include?(position[0]) && position[1].to_i.between?(1, 8))
    else # 'position' is an array [row, col]
      return !(position.all? { |e| e.between?(0, 7) })
    end
  end

  def valid_init_pos?(piece, position)
    return false if out_of_bounds?(position)

    position = translate(position)
    piece = PIECES[piece]
    if current_player == 'white'
      @white[piece].each { |element| return true if element.square == position }
    else
      @black[piece].each { |element| return true if element.square == position }
    end
    false
  end

  def valid_end_pos?(position)
    # 1. checks if pos is out of bounds
    return false if out_of_bounds?(position)

    end_position = translate(position)
    current_pos = translate(@selected_piece[1])
    piece = @board[current_pos[0]][current_pos[1]]

    # 2. passes the position to the piece to check if it's a valid move
    if %w[R B Q P].include?(@selected_piece[0])
      return false unless piece.valid_move?(end_position, @board)
    else
      return false unless piece.valid_move?(end_position)
    end

    # 3. checks if the destination square can be taken
    can_take?(end_position)

    # if all 3 tests pass, then end position is valid
  end

  def can_take?(dest)
    dest_content = @board[dest[0]][dest[1]]
    return (dest_content.nil? || dest_content.color != @current_player) ? true : false
  end

  def legal?(dest, piece_square = translate(@selected_piece[1])) # is the king in check after moving
    temp_piece = @board[piece_square[0]][piece_square[1]].dup
    temp_checking = @checking_piece.dup unless @checking_piece.empty?

    @board[piece_square[0]][piece_square[1]] = nil
    @checking_piece.clear
    # binding.pry
    test_piece = temp_piece.dup
    test_piece = update_piece(test_piece, dest) # test_piece.square = dest

    dest_content = @board[dest[0]][dest[1]].dup
    @board[dest[0]][dest[1]] = test_piece

    result = test_piece.class == King ? check?(dest) : check?

    @board[piece_square[0]][piece_square[1]] = update_piece(temp_piece, piece_square)
    @board[dest[0]][dest[1]] = dest_content
    @checking_piece = temp_checking unless temp_checking.nil?

    !result
  end

  def translate(position)
    # translates CHESS NOTATION into Ruby indexes [row, col]
    position = position.reverse.split('')
    position[0] = 8 - position[0].to_i 
    position[1] = COL_LETTERS.index(position[1])
    position
  end
end