# frozen_string_literal: true
require_relative '../lib/chess_game'

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
      current_player_before = subject.instance_variable_get(:@current_player)
      subject.switch_current_player
      current_player_after = subject.instance_variable_get(:@current_player)
      expect(current_player_before.color).not_to eq(current_player_after.color)
    end
  end
end