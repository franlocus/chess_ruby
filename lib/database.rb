# frozen_string_literal: true

module Database
  def save_game
    Dir.mkdir 'saved_games' unless Dir.exist? 'saved_games'
    @filename = 'last_game.yaml'
    File.open("saved_games/#{@filename}", 'w') { |file| file.write save_to_yaml }
    abort 'Game saved succesfully'.reverse_color
  end

  def save_to_yaml
    YAML.dump(
      'board' => @board,
      'player_white' => @player_white,
      'player_black' => @player_black,
      'moves_calculator' => @moves_calculator,
      'interface' => @interface,
      'moves_controller' => @moves_controller,
      'current_player' => @current_player
    )
  end

  def load_game
    load_saved_file
    turn_order
    File.delete("saved_games/last_game.yaml") if File.exist?("saved_games/last_game.yaml")
  end

  def load_saved_file
    file = YAML.load(File.read('saved_games/last_game.yaml'))
    @board = file['board']
    @player_white = file['player_white']
    @player_black = file['player_black']
    @moves_calculator = file['moves_calculator']
    @interface = file['interface']
    @moves_controller = file['moves_controller']
    @current_player = file['current_player']
  end
end