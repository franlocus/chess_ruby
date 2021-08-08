# frozen_string_literal: true

require_relative '../lib/moves_calculator'
require_relative '../lib/board'
require_relative '../lib/moves_controller'
require_relative '../lib/interface'

describe MovesCalculator do
  let(:board) { Board.new }
  let(:subject) { described_class.new(board) }
  describe '#legal_moves' do
    it 'take coordinates in argument and output legal moves' do
      expect(subject.legal_moves([7, 3])).not_to be_nil
    end
    it 'None mayor piece has moves initially except knights' do
      recopiled_legal_moves = []
      8.times { |i| recopiled_legal_moves << subject.legal_moves([7, i - 1]) }
      expect(recopiled_legal_moves.flatten(1)).to match_array([[5, 0], [5, 2], [5, 5], [5, 7]]
      )
    end
    matcher :every_piece_has_moves do
      match { |array_2d| array_2d.all? { |array| !array.empty? } }
    end
    it 'All white mayors pieces have certain moves initially if white pawns are removed' do
      subject.board.squares[6].map! { nil }
      recopiled_legal_moves = []
      8.times { |i| recopiled_legal_moves << subject.legal_moves([7, i - 1]) }
      expect(recopiled_legal_moves.flatten(1)).to match_array([[6, 7], [5, 7], [4, 7], [3, 7], [2, 7], [1, 7], [6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [5, 0], [5, 2], [6, 3], [6, 3], [5, 4], [4, 5], [3, 6], [2, 7], [6, 1], [5, 0], [6, 4], [5, 5], [4, 6], [3, 7], [6, 2], [5, 1], [4, 0], [6, 3], [5, 3], [4, 3], [3, 3], [2, 3], [1, 3], [6, 5], [6, 4], [6, 3], [6, 6], [5, 7], [6, 4], [5, 3], [4, 2], [3, 1], [2, 0], [6, 4], [5, 5], [5, 7]]
      )
      expect(recopiled_legal_moves).to every_piece_has_moves
    end
  end
  context 'pawns movements' do
    let(:subject) { described_class.new(board) }
    let(:player_white) { Player.new(true) }
    let(:player_black) { Player.new(false) }
    let(:interface) { Interface.new(board) }
    let(:moves_controller) { MovesController.new(board, interface) }
    # white
    it 'returns 2 pawns\'s moves from d2' do
      expect(subject.legal_moves([6, 3])).to eq([[5, 3], [4, 3]])
    end
    it 'returns 1 pawns\'s move from a2 because pawn has moved' do
      subject.board.squares[6][0].moved = true
      expect(subject.legal_moves([6, 0])).to match_array([[5, 0]])
    end
    it 'returns 1 pawns\'s move from e2 if there is a piece in e4' do
      subject.board.squares[4][4] = subject.board.squares[0][3]
      expect(subject.legal_moves([6, 4])).to match_array([[5, 4]])
    end
    it 'can capture diagonals from f2 if there is an enemy piece in e3 and g3' do
      subject.board.squares[5][4] = subject.board.squares[0][3]
      subject.board.squares[5][6] = subject.board.squares[0][2]
      expect(subject.legal_moves([6, 5])).to match_array([[4, 5], [5, 4], [5, 5], [5, 6]])
    end
    it 'can move en passant' do
      board = subject.board
      moves_controller.make_move([6, 4], [3, 4], player_white)
      moves_controller.make_move([1, 3], [3, 3], player_black)
      expect(subject.legal_moves([3, 4])).to match_array([[2, 3], [2, 4]])
    end
    # black
    it 'returns 2 pawns\'s moves from d7' do
      expect(subject.legal_moves([1, 3])).to eq([[2, 3], [3, 3]])
    end
    it 'returns 1 pawns\'s move from a7 because pawn has moved' do
      subject.board.squares[1][0].moved = true
      expect(subject.legal_moves([1, 0])).to match_array([[2, 0]])
    end
    it 'returns 1 pawns\'s move from e7 if there is a piece in e5' do
      subject.board.squares[3][4] = subject.board.squares[7][3]
      expect(subject.legal_moves([1, 4])).to match_array([[2, 4]])
    end
    it 'can capture diagonals from b7 if there is an enemy piece in a6 and c6' do
      subject.board.squares[2][0] = subject.board.squares[7][0]
      subject.board.squares[2][2] = subject.board.squares[7][7]
      expect(subject.legal_moves([1, 1])).to match_array([[2, 0], [2, 1], [2, 2], [3, 1]])
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
    # white
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
    describe 'white queen with starts in central square e4 ' do
      it 'returns array with moves to capture and blank squares' do
        subject.board.squares[4][4] = subject.board.squares[7][3]
        subject.board.squares[4][4].square = [4, 4]
        expect(subject.legal_moves([4, 4])).to match_array([[1, 1], [1, 4], [1, 7], [2, 2], [2, 4], [2, 6], [3, 3], [3, 4], [3, 5], [4, 0], [4, 1], [4, 2], [4, 3], [4, 5], [4, 6], [4, 7], [5, 3], [5, 4], [5, 5]])
      end
    end
    # black
    describe 'black knight first 2 moves ' do
      it 'returns array with moves in row 5' do
        expect(subject.legal_moves([0, 1])).to match_array([[2, 0], [2, 2]])
      end
    end
  end
end


# TODO fix KING MOVEMENTS
