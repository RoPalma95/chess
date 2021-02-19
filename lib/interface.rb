
require 'rainbow'

module Interface
  def introduction
    puts <<~INTRODUCTION
                WELCOME TO RUBY CHESS
    
    Chess is a strategy game for two players, in which each player will try to capture or 'take' the opponent's King.
    Each turn, each player can move only one of their pieces according to each piece's movement constraints. There are two
    ways of winning the game:
      
      1. Checkmate. A player's King will be taken next turn and there is nothing the player can do to avoid it.
      2. Concede. The player keeps repeating the same moves unable to remove their King's check, thus conceding defeat.

    Instructions:
      * Players will decide who goes first. Whoever goes first will be in charge of the White pieces, while the other player
        will be in charge of the Black pieces.
      * On their turn, Players will be prompted to enter a move using the following format:
        - They will be asked to select a piece to move. This will be done by typing the correspondig letter for each type of piece:
          
            Queen --> Q or q
            King --> K or k
            Rook --> R or r
            Knight --> N or n
            Bishop --> B or b
            Pawn --> P or p
          
          Players will have to be certain of which piece they want to move because, once selected, they cannot change their selection.
        
        - After selecting a piece, the piece's current location will be asked. This location will have to be entered using the
          following format: ColumnRow. Example: A1, refers to the piece on column A, row 1. Notice the lack of spaces in the input.
        
        - Next, Players will be asked to input a destination for the selected piece. This destination has to meet two criteria:

          1. It can be reached by the selected piece. That is, the piece is allowed to move to the selected destination by its movement constraints.
          2. It is a legal movement. A movement is legal if afterwards, the Player's King is not in check or no longer in check.

          If any of both criteria is not met, the Player will be asked to input a different destination. In the case that the selected move
          is not legal, the Player will be allowed to select a different piece to move.
        
      * Players will alternate inputting movements until one of them is in Checkmate, making their opponent the winner.

      * At any point in the game, Players can choose to save the current state of the game and exiting the application by typing the letter 'S' or 's' and 
        hitting the return key. A confirmation message will be displayed and the application will end.

        Press any key to continue...
    INTRODUCTION
    gets.chomp
    game_menu
  end

  def game_menu
    system('clear') || system('clr')
    puts 'Select one of the following option to continue:'
    puts "\t[N]ew Game"
    puts "\t[L]oad Game"
    mode = gets.chomp.upcase
    if mode == 'N'
      return
    else
      load_game
    end
  end

  def draw_board
    system('clear') || system('clr')
    puts "\n"
    print "\t   A     B     C     D     E     F     G     H"
    puts "\n\n"
    print_rows
  end

  def print_rows
    @board.each_with_index do |row, r_ix|
      print "    #{8 - r_ix}\t"
      row.each_with_index do |square, sq_ix|
        icon = choose_icon(square)
        if r_ix.even?
          print sq_ix.odd? ? "\e[40m  #{icon}   \e[0m" : "\e[100m  #{icon}   \e[0m"
        else
          print sq_ix.even? ? "\e[40m  #{icon}   \e[0m" : "\e[100m  #{icon}   \e[0m"
        end
      end
      puts "\n"
    end
    puts "\n"
  end

  def choose_icon(square)
    case square.class.to_s
    when 'Queen'
      square.color == 'white' ? "#{"\u2655".encode('utf-8')}" : "#{"\u265B".encode('utf-8')}"
    when 'King'
      square.color == 'white' ? "#{"\u2654".encode('utf-8')}" : "#{"\u265A".encode('utf-8')}"
    when 'Rook'
      square.color == 'white' ? "#{"\u2656".encode('utf-8')}" : "#{"\u265C".encode('utf-8')}"
    when 'Knight'
      square.color == 'white' ? "#{"\u2658".encode('utf-8')}" : "#{"\u265E".encode('utf-8')}"
    when 'Bishop'
      square.color == 'white' ? "#{"\u2657".encode('utf-8')}" : "#{"\u265D".encode('utf-8')}"
    when 'Pawn'
      square.color == 'white' ? "#{"\u2659".encode('utf-8')}" : "#{"\u265F".encode('utf-8')}"
    else
      " "
    end
  end
end

