# frozen_string_literal: true

class ChessGame
  attr_accessor :current_player
  attr_reader :moves_controller, :player_white, :player_black, :interface, :moves_calculator, :board

  def initialize(interface, player_white, player_black, moves_controller, board, moves_calculator)
    @player_white = player_white
    @player_black = player_black
    @interface = interface
    @moves_controller = moves_controller
    @board = board
    @moves_calculator = moves_calculator
  end

  def play_game
    game_type = interface.game_type
    game_type == 1 ? new_game : load_game
  end

  # private after all test

  def new_game
    @current_player ||= player_white
    turn_order
    game_over
  end

  def turn_order
  # king in check?
  # normal_turn || forced_turn
    loop do
      interface.display_score_board
      movement = forced_turn? ? forced_piece_selection : freely_piece_selection
      moves_controller.make_move(movement.first, movement.last, current_player)
      # return if checkmate || stalemate
      switch_current_player
    end
  end

  def end_condition?
    
  end

  def forced_turn?
    moves_calculator.under_check?(current_player.is_white)
  end

  def freely_piece_selection
    piece_from = interface.player_select_piece(current_player.is_white)
    piece_to = interface.player_select_move(piece_from, current_player.is_white)
    [piece_from, piece_to]
  end

  def forced_piece_selection
    king = board.king(current_player.is_white)
    checker = moves_calculator.checker(king)
    forced_pieces = moves_calculator.forced_pieces(king, checker)
    interface.player_forced_select(forced_pieces, current_player.is_white)
  end

  def game_over
    # puts current_player WIN
    # checkmate?
    # stalemate?
  end

  def switch_current_player
    self.current_player = if current_player == player_white
                            player_black
                          else
                            player_white
                          end
  end
end
