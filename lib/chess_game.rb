# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/interface'
require_relative '../lib/moves_controller'
# TODO initialize interface in main?
# TODO initialize board in interface

class ChessGame
  def initialize
    @board = Board.new
    @player_white = Player.new('white')
    @player_black = Player.new('black')
    @interface = Interface.new(@board)
    @moves_controller = MovesController.new
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
      piece_from = @interface.player_select_piece(@current_player)
      piece_to = @interface.player_input_move(piece_from)
      @moves_controller.make_move(piece_from, piece_to)
      # break if conditions win
      switch_current_player
    end
  end

  def game_over
    
  end

  def switch_current_player
    @current_player = if @current_player == @player_white
                        @player_black
                      else
                        @player_white
                      end
  end
end
