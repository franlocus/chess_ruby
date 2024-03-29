# frozen_string_literal: true
require_relative '../lib/chess_game'
require_relative '../lib/player'
require_relative '../lib/moves_controller'
require_relative '../lib/interface'
require_relative '../lib/moves_calculator'

describe ChessGame do
  let(:board) { Board.new }
  let(:moves_calculator) { MovesCalculator.new(board) }  
  let(:player_white) { Player.new(true) }
  let(:player_black) { Player.new(false) }
  let(:interface) { Interface.new(board, moves_calculator , player_white, player_black) }
  let(:subject) { described_class.new(interface, Player.new(true), Player.new(false), MovesController.new(board, interface), board, moves_calculator) }
  
  describe '#freely_piece_selection' do
    before do
      subject.current_player = Player.new(true)
      allow(interface).to receive(:print)
      allow(interface).to receive(:puts)
      valid_input = 'a2'
      valid_move = 'a3'
      allow(interface).to receive(:gets).and_return(valid_input, valid_move)
    end
    it 'returns array with 2 coordinates from algebraic a2,a3' do
      expect(subject.freely_piece_selection).to match_array([[6, 0], [5, 0]])
    end
  end

  describe '#forced_piece_selection' do
    before do
      subject.current_player = Player.new(true)
      allow(interface).to receive(:print)
      allow(interface).to receive(:puts)
      valid_input = 'a2'
      valid_move = 'a3'
      allow(interface).to receive(:gets).and_return(valid_input, valid_move)
    end
    it 'returns array with 2 coordinates from algebraic a2,a3' do
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

class NilClass
  def unicode(printing_moves = false)
    if printing_moves
      '◌ '.bg_green
    else
      '  '
    end
  end
end