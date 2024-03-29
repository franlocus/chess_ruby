# frozen_string_literal: true

require_relative 'database'

class ChessGame
  include Database
  attr_accessor :current_player
  attr_reader :moves_controller, :player_white, :player_black, :interface, :moves_calculator, :board

  def initialize(args)
    @player_white = args['player_white']
    @player_black = args['player_black']
    @interface = args['interface']
    @moves_controller = args['moves_controller']
    @board = args['board']
    @moves_calculator = args['moves_calculator']
  end

  # private after all test
  def play_game
    game_type = interface.game_type
    game_type == 1 ? new_game : load_game
  end

  def new_game
    @current_player ||= player_white
    turn_order
    game_over
  end

  def turn_order
    loop do
      interface.display_score_board
      return if game_over?

      movement = forced_turn? ? forced_piece_selection : freely_piece_selection
      moves_controller.make_move(movement.first, movement.last, current_player)
      switch_current_player
    end
  end

  def game_over?
    checkmate? || stalemate?
  end

  def checkmate?
    return false unless forced_turn?

    king = board.king(current_player.is_white)
    checker = moves_calculator.checker(king)
    forced_pieces = moves_calculator.forced_pieces(king, checker)
    forced_pieces.empty?
  end

  def stalemate?
    moves_calculator.all_player_moves(current_player.is_white).empty?
  end

  def forced_turn?
    moves_calculator.under_check?(current_player.is_white)
  end

  def freely_piece_selection
    piece_from = interface.player_select_piece(current_player.is_white)
    return save_game if piece_from =~ /^save$/

    piece_to = interface.player_select_move(piece_from, current_player.is_white)
    [piece_from, piece_to]
  end

  def forced_piece_selection
    king = board.king(current_player.is_white)
    checker = moves_calculator.checker(king)
    forced_pieces = moves_calculator.forced_pieces(king, checker)
    interface.player_forced_select(forced_pieces, current_player.is_white)
  end

  def switch_current_player
    self.current_player = if current_player == player_white
                            player_black
                          else
                            player_white
                          end
  end

  def game_over
    if checkmate?
      puts  "#{current_player.is_white ? 'BLACK' : 'WHITE'} WINS by CHECKMATE!".reverse_color
    else
      puts  "It's a DRAW by STALEMATE!".reverse_color
    end
  end
end
