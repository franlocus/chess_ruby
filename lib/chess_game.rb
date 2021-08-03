# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/interface'
# TODO initialize interface in main?

class ChessGame
  def initialize
    @board = Board.new
    @player_white = Player.new('white')
    @player_black = Player.new('black')
    @interface = Interface.new(@board)
  end

  def play_game
    game_type = @interface.game_type
    game_type == 1 ? new_game : load_game
  end

  def new_game
    @interface.display_board
    @current_player || @player_white
    turn_order
    game_over
  end

  def turn_order
    loop do
      
    end
  end

  def game_over
    
  end

  def switch_current_player
    @current_player = @current_player == @player_white ? @player_black : @player_black
  end
end
