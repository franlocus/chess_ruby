# frozen_string_literal: true

# TODO: play_game in main?
# TODO: initialize interface in main?
# TODO: initialize board in interface

class ChessGame
  attr_accessor :current_player
  attr_reader :moves_controller, :player_white, :player_black, :interface

  def initialize(interface, player_white, player_black, moves_controller, board)
    @player_white = player_white
    @player_black = player_black
    @interface = interface
    @moves_controller = moves_controller
    @board = board
  end

  def play_game
    game_type = interface.game_type
    game_type == 1 ? new_game : load_game
  end

  # private after all test

  def new_game
    @current_player || player_white
    turn_order
    game_over
  end

  def turn_order
    loop do
      interface.display_board
      piece_from = interface.player_select_piece(current_player.is_white)
      piece_to = interface.player_select_move(piece_from)
      moves_controller.make_move(piece_from, piece_to)
      # break if conditions win
      switch_current_player
    end
  end

  def game_over
    
  end

  def switch_current_player
    self.current_player = if current_player == player_white
                            player_black
                          else
                            player_white
                          end
  end
end
