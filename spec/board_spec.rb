# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/colorize'
require_relative '../lib/square'

describe Board do
  describe '#initialize' do
    it 'starts with 7 row' do
      expect(subject.squares.size).to eq(8)
    end
    it 'starts with 64 squareboard' do
      expect(subject.squares.flatten.size).to eq(64)
      expect(subject.squares.flatten).to all(be_a(Square))
      # the first square is bg_white
      expect(subject.squares.flatten.first.bg_color).to eq('white')
      # the last square is bg_white
      expect(subject.squares.flatten.last.bg_color).to eq('white')
    end

    it 'setup white and black pieces' do
      # rook white
      expect(subject.squares[7].first.piece).to be_a(Rook)
      # pawn white
      expect(subject.squares[6].first.piece).to be_a(Pawn)
      # rook black
      expect(subject.squares[0].first.piece).to be_a(Rook)
      # pawn black
      expect(subject.squares[1].first.piece).to be_a(Pawn)
    end
  end
  describe '#display' do
    before do
      puts "\n"
      puts subject.display
      allow(subject).to receive(:print)
    end
    it 'print colored chessboard with row number and letters row' do
      expect(subject).to receive(:print)
      subject.display
    end
  end
end