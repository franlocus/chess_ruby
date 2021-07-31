# frozen_string_literal: true
require_relative '../lib/board'
require_relative '../lib/colorize'
require_relative '../lib/square'


describe Board do
  describe '#initialize' do
    it 'starts with 7 row' do
      expect(subject.board.size).to eq(8)
    end
    it 'starts with 64 squareboard' do
      expect(subject.board.flatten.size).to eq(64)
      expect(subject.board.flatten).to all(be_a(Square))

      # the first is white
      expect(subject.board.flatten.first.bg_color).to eq('white')
      # the last is white
      expect(subject.board.flatten.last.bg_color).to eq('white')
    end
  end
  describe '#display' do
    before do
      allow(subject).to receive(:print)
    end
    it 'puts colored chessboard with row number and letters row' do
      expect(subject).to receive(:print)
      subject.display
    end
  end
end