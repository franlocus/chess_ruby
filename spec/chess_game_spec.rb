# frozen_string_literal: true
require_relative '../lib/chess_game'
require_relative '../lib/player'
require_relative '../lib/moves_controller'
require_relative '../lib/interface'

describe ChessGame do
  describe '#initialize' do
    it 'init board and players' do
      board = subject.instance_variable_get(:@board)
      player_white = subject.instance_variable_get(:@player_white)
      player_black = subject.instance_variable_get(:@player_black)
      expect(board).to be_a(Board)
      expect(player_white).to be_a(Player)
      expect(player_white.color).to eq('white')
      expect(player_black).to be_a(Player)
      expect(player_black.color).to eq('black')
    end
  end

  describe '#switch_current_player' do
    it 'change current player according' do
      subject.switch_current_player # make current = white
      expect { subject.switch_current_player }.to change { subject.instance_variable_get(:@current_player).color }.from('white').to('black')
      expect { subject.switch_current_player }.to change { subject.instance_variable_get(:@current_player).color }.from('black').to('white')
    end
  end

  describe '#new_game' do
    before do
      allow(subject).to receive(:turn_order)
      allow(subject).to receive(:game_over)
    end
    it 'calls to interface to display board' do
      interface = subject.instance_variable_get(:@interface)
      expect(interface).to receive(:display_board)
      subject.new_game
    end
  end

  describe '#turn_order' do
    xit '' do
      
    end
  end
end