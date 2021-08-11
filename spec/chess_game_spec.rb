# frozen_string_literal: true
require_relative '../lib/chess_game'
require_relative '../lib/player'
require_relative '../lib/moves_controller'
require_relative '../lib/interface'
require_relative '../lib/moves_calculator'

describe ChessGame do
  let(:board) { Board.new }
  let(:moves_calculator) { MovesCalculator.new(board) }  
  let(:interface) {Interface.new(board, moves_calculator)}
  let(:subject) { described_class.new(interface, Player.new(true), Player.new(false), MovesController.new(board, interface), board, moves_calculator) }
  describe '#initialize' do
    it 'init board and players' do
      # output just because love to see it printed <3
      puts
      puts subject.display_score_board
      # #############################################
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
  describe '#freely_piece_selection' do
    before do
      subject.current_player = Player.new(true)
      allow(subject).to receive(:puts)
      valid_input = 'a2'
      valid_move = 'a3'
      allow(interface).to receive(:gets).and_return(valid_input, valid_move)
    end
    it 'returns array with 2 coordinates from algebraic a2,a3' do
      expect(subject.freely_piece_selection).to match_array([[6, 0], [5, 0]])
    end
  end

  describe '#freely_piece_selection' do
    before do
      subject.current_player = Player.new(true)
      allow(subject).to receive(:puts)
      valid_input = 'a2'
      valid_move = 'a3'
      allow(interface).to receive(:gets).and_return(valid_input, valid_move)
    end
    xit 'returns array with 2 coordinates from algebraic a2,a3' do
      expect(subject.freely_piece_selection).to match_array([[6, 0], [5, 0]])
    end
  end

  describe '#switch_current_player' do
    it 'change current player according' do
      subject.switch_current_player # make current = white
      expect { subject.switch_current_player }.to change { subject.current_player.is_white }.from(true).to(false)
      expect { subject.switch_current_player }.to change { subject.instance_variable_get(:@current_player).is_white }.from(false).to(true)
    end
  end
end