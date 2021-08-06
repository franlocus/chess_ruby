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
    let(:subject) { described_class.new(Board.new) }
    describe 'white king can move if there is no initial pawns' do
      it 'returns moves in row 6' do
        subject.board.squares[6].map! { nil }
        expect(subject.legal_moves([7, 4])).to match_array([[6, 5], [6, 4], [6, 3]])
      end
    end
    describe 'white king can castle short if there aren\'t knight and bishop ' do
      before do
        allow(subject.board).to receive(:defended_squares_by).and_return([])
      end
      it 'returns array with short castle move included [7, 6]' do
        subject.board.squares[7][5] = nil
        subject.board.squares[7][6] = nil
        expect(subject.legal_moves([7, 4])).to match_array([[7, 5], [7, 6]])
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
        expect(subject.legal_moves([7, 4])).to match_array([[7, 3], [7, 2]])
      end
    end
    describe 'white knight first 2 moves ' do
      it 'returns array with moves in row 5' do
        expect(subject.legal_moves([7, 1])).to match_array([[5, 0], [5, 2]])
      end
    end
    describe 'black knight first 2 moves ' do
      it 'returns array with moves in row 5' do
        expect(subject.legal_moves([0, 1])).to match_array([[2, 0], [2, 2]])
      end
    end
    describe 'white queen in central square e4 ' do
      it 'returns array with moves to capture and blank squares' do
        subject.board.squares[4][4] = subject.board.squares[7][3] 
        subject.board.squares[4][4].square = [4, 4]
        expect(subject.legal_moves([4, 4])).to match_array([[1, 1], [1, 4], [1, 7], [2, 2], [2, 4], [2, 6], [3, 3], [3, 4], [3, 5], [4, 0], [4, 1], [4, 2], [4, 3], [4, 5], [4, 6], [4, 7], [5, 3], [5, 4], [5, 5]])
      end
    end
  end
end


# TODO fix KING MOVEMENTS
