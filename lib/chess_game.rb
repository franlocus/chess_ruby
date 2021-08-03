# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/board'

class ChessGame
  def initialize
    @board = Board.new
    @player_white = Player.new('white')
    @player_black = Player.new('black')
    @current_player = @player_white
  end

  def play_game
    game_type = @interface.game_type
    new_game if game_type == 1
    load_game if game_type == 2
  end

  def switch_current_player
    @current_player = @current_player == @player_white ? @player_black : @player_black 
  end
end