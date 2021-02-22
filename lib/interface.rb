
require 'rainbow'
require_relative '../lib/save_game'

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
      * On your turn select the piece you want to move by inputting its corresponding letter:

            Queen --> Q or q
            King --> K or k
            Rook --> R or r
            Knight --> N or n
            Bishop --> B or b
            Pawn --> P or p

      * Input the selected piece's location. Example: A1 <- references a piece in column A, row 1

      * Input a destination for the selected piece

      * If you'd like to save the game, type 's' or 'S' at the start of your turn

      Press any key to continue...
    INTRODUCTION
    gets.chomp
    game_menu
  end

  def game_menu
    system('clear') || system('clr')
    puts 'Select one of the following options to continue:'
    puts "\t[N]ew Game"
    puts "\t[L]oad Game"
    mode = gets.chomp.upcase
    if mode == 'N'
      return
    else
      load_game('chess_saved_game.yaml')
      return 'loaded'
    end
  end

  def draw_board
    system('clear') || system('clr')
    puts "[S]ave and quit"
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

