# frozen_string_literal: true

require_relative '../lib/moves_calculator'
require_relative '../lib/board'

describe MovesCalculator do
  let(:subject) { described_class.new(Board.new) }
  describe '#legal_moves' do
    it 'take coordinates in argument and output legal moves' do
      expect(subject.legal_moves([7, 3])).not_to be_nil
    end
  end
  context 'modified boards' do
    describe 'white king can move if there is no initial pawn' do
      let(:subject_with_no_white_pawns) { described_class.new(Board.new) }
      it 'take coordinates in argument and output legal moves' do
        subject.board.squares[6].map! { nil }
        expect(subject.legal_moves([7, 4])).to eq([[6, 5], [6, 4], [6, 3]])
      end
    end
    describe 'white king can castle short if there aren\'t knight and bishop ' do
      before do
        allow(subject.board).to receive(:defended_squares_by).and_return([])
      end
      it 'returns array with short castle move included [7, 6]' do
        subject.board.squares[7][5] = nil
        subject.board.squares[7][6] = nil
        expect(subject.legal_moves([7, 4])).to eq([[7, 5], [7, 6]])
      end
    end
    describe 'white king can castle long if there aren\'t queen, knight and bishop ' do
      before do
        allow(subject.board).to receive(:defended_squares_by).and_return([])
      end
      it 'returns array with long castle move included [7, 2]' do
        subject.board.squares[7][1] = nil
        subject.board.squares[7][2] = nil
        subject.board.squares[7][3] = nil
        expect(subject.legal_moves([7, 4])).to eq([[7, 3], [7, 2]])
      end
    end
  end
end


# TODO fix KING MOVEMENTS
