# frozen_string_literal: true

require 'yaml'
require_relative '../lib/chess_game'
require_relative '../lib/player'
require_relative '../lib/board'
require_relative '../lib/interface'
require_relative '../lib/moves_controller'
require_relative '../lib/moves_calculator'
require_relative '../lib/colorize'

class Game
  def initialize
    @board = Board.new
    @moves_calculator = MovesCalculator.new(@board)
    @player_white = Player.new(true)
    @player_black = Player.new(false)
    @interface = Interface.new(@board, @moves_calculator, @player_white, @player_black)
    @moves_controller = MovesController.new(@board, @interface)
  end

  def play
    args = {
      'board' => @board,
      'interface' => @interface,
      'moves_calculator' => @moves_calculator,
      'player_white' => @player_white,
      'player_black' => @player_black,
      'moves_controller' => @moves_controller
    }
    ChessGame.new(args).play_game
  end
end

class NilClass
  def unicode(printing_moves = false)
    if printing_moves
      '◌ '.bg_green
    else
      '  '
    end
  end
end

chess = Game.new

chess.play