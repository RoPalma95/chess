
require 'yaml'
require 'pry'

module SaveAndLoad
  def save_game
    Dir.mkdir('saved_game') unless Dir.exist?('saved_game')
    filename = 'chess_saved_game.yaml'
    File.open("saved_game/#{filename}", 'w') do |file| 
      YAML.dump([] << self, file)
    end

    display_file_location(filename)
  rescue SystemCallError => e
    puts "Error while writing to file #{filename}."
    puts e
  end

  def load_game(file_name)
    loaded_file = File.open("saved_game/#{file_name}", 'r') { |f| YAML.load(f) }

    self.board = loaded_file[0].board
    self.current_player = loaded_file[0].current_player
    self.selected_piece = loaded_file[0].selected_piece
    self.white = loaded_file[0].white
    self.black = loaded_file[0].black
    self.checking_piece = loaded_file[0].checking_piece
  rescue SystemCallError => e
    puts "Error while loading file #{filename}."
    puts e
  end

  # def serialize
  #   YAML.dump(
  #     'board' => @board,
  #     'current_player' => @current_player,
  #     'selected_piece' => @selected_piece,
  #     'white' => @white,
  #     'black' => @black,
  #     'checking_piece' => @checking_piece
  #   )
  # end

  def display_file_location(file_name)
    puts "The current state of the board has been saved at 'saved_game/#{file_name}"
    sleep 1
  end
end