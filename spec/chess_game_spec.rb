# frozen_string_literal: true
require_relative '../lib/chess_game'
require_relative '../lib/player'
require_relative '../lib/moves_controller'
require_relative '../lib/interface'

describe ChessGame do
  let(:board) { Board.new }
  let(:subject) { described_class.new(Interface.new(board), Player.new(true), Player.new(false), MovesController.new, board) }
  describe '#initialize' do
    it 'init board and players' do
      interface = subject.instance_variable_get(:@interface)
      player_white = subject.instance_variable_get(:@player_white)
      player_black = subject.instance_variable_get(:@player_black)
      expect(interface).to be_a(Interface)
      expect(player_white).to be_a(Player)
      expect(player_white.is_white).to be_truthy
      expect(player_black).to be_a(Player)
      expect(player_black.is_white).to be_falsy
    end
  end

  describe '#switch_current_player' do
    it 'change current player according' do
      subject.switch_current_player # make current = white
      expect { subject.switch_current_player }.to change { subject.instance_variable_get(:@current_player).is_white }.from(true).to(false)
      expect { subject.switch_current_player }.to change { subject.instance_variable_get(:@current_player).is_white }.from(false).to(true)
    end
  end
end