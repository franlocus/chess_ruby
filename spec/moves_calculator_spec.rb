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
      expect(subject.legal_moves([7, 3], true)).not_to be_nil
    end
    it 'None mayor piece has moves initially except knights' do
      recopiled_legal_moves = []
      8.times { |i| recopiled_legal_moves << subject.legal_moves([7, i - 1], true) }
      expect(recopiled_legal_moves.flatten(1)).to match_array([[5, 0], [5, 2], [5, 5], [5, 7]]
      )
    end
    matcher :every_piece_has_moves do
      match { |array_2d| array_2d.all? { |array| !array.empty? } }
    end
    it 'All white mayors pieces have certain moves initially if white pawns are removed' do
      subject.board.squares[6].map! { nil }
      recopiled_legal_moves = []
      8.times { |i| recopiled_legal_moves << subject.legal_moves([7, i - 1], true) }
      expect(recopiled_legal_moves.flatten(1)).to match_array([[6, 7], [5, 7], [4, 7], [3, 7], [2, 7], [1, 7], [6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [5, 0], [5, 2], [6, 3], [6, 3], [5, 4], [4, 5], [3, 6], [2, 7], [6, 1], [5, 0], [6, 4], [5, 5], [4, 6], [3, 7], [6, 2], [5, 1], [4, 0], [6, 3], [5, 3], [4, 3], [3, 3], [2, 3], [1, 3], [6, 5], [6, 4], [6, 3], [6, 6], [5, 7], [6, 4], [5, 3], [4, 2], [3, 1], [2, 0], [6, 4], [5, 5], [5, 7]]
      )
      expect(recopiled_legal_moves).to every_piece_has_moves
    end
  end
  context 'pawns movements' do
    let(:subject) { described_class.new(board) }
    let(:player_white) { Player.new(true) }
    let(:player_black) { Player.new(false) }
    let(:interface) { Interface.new(board, MovesCalculator.new(board)) }
    let(:moves_controller) { MovesController.new(board, interface) }
    # white
    it 'returns 2 pawns\'s moves from d2' do
      expect(subject.legal_moves([6, 3], true)).to eq([[5, 3], [4, 3]])
    end
    it 'returns 1 pawns\'s move from a2 because pawn has moved' do
      subject.board.squares[6][0].moved = true
      expect(subject.legal_moves([6, 0], true)).to match_array([[5, 0]])
    end
    it 'returns 1 pawns\'s move from e2 if there is a piece in e4' do
      subject.board.squares[4][4] = subject.board.squares[0][3]
      expect(subject.legal_moves([6, 4], true)).to match_array([[5, 4]])
    end
    it 'returns 1 pawns\'s move from a6 if there is a piece in b7' do
      moves_controller.make_move([6, 0], [5, 0], player_white)
      moves_controller.make_move([5, 0], [4, 0], player_white)
      moves_controller.make_move([4, 0], [3, 0], player_white)
      moves_controller.make_move([3, 0], [2, 0], player_white)
      expect(subject.legal_moves([2, 0], true)).to match_array([[1, 1]])
    end
    context 'the pawn moves along the A column' do
      it 'returns 1 up move from a6 if there is not piece at a7, then follow the path' do
        moves_controller.make_move([6, 0], [5, 0], player_white)
        moves_controller.make_move([5, 0], [4, 0], player_white)
        moves_controller.make_move([4, 0], [3, 0], player_white)
        moves_controller.make_move([3, 0], [2, 0], player_white)
        subject.board.delete_piece([1, 0])
        expect(subject.legal_moves([2, 0], true)).to match_array([[1, 0], [1, 1]])
        moves_controller.make_move([2, 0], [1, 0], player_white)
        subject.board.delete_piece([0, 1])
        expect(subject.legal_moves([1, 0], true)).to be_empty
      end
    end
    it 'can capture diagonals from f2 if there is an enemy piece in e3 and g3' do
      subject.board.squares[5][4] = subject.board.squares[0][3]
      subject.board.squares[5][6] = subject.board.squares[0][2]
      expect(subject.legal_moves([6, 5], true)).to match_array([[4, 5], [5, 4], [5, 5], [5, 6]])
    end
    it 'can move en passant' do
      board = subject.board
      moves_controller.make_move([6, 4], [3, 4], player_white)
      moves_controller.make_move([1, 3], [3, 3], player_black)
      expect(subject.legal_moves([3, 4], true)).to match_array([[2, 3], [2, 4]])
    end
    # black
    it 'returns 2 pawns\'s moves from d7' do
      expect(subject.legal_moves([1, 3], false)).to eq([[2, 3], [3, 3]])
    end
    it 'returns 1 pawns\'s move from a7 because pawn has moved' do
      subject.board.squares[1][0].moved = true
      expect(subject.legal_moves([1, 0], false)).to match_array([[2, 0]])
    end
    it 'returns 1 pawns\'s move from e7 if there is a piece in e5' do
      subject.board.squares[3][4] = subject.board.squares[7][3]
      expect(subject.legal_moves([1, 4], false)).to match_array([[2, 4]])
    end
    context 'the pawn moves along the A column' do
      it 'returns 1 down move from a3 if there is not piece at a2, then follow the path' do
        moves_controller.make_move([1, 0], [2, 0], player_black)
        moves_controller.make_move([2, 0], [3, 0], player_black)
        moves_controller.make_move([3, 0], [4, 0], player_black)
        moves_controller.make_move([4, 0], [5, 0], player_black)
        subject.board.delete_piece([6, 0])
        expect(subject.legal_moves([5, 0], false)).to match_array([[6, 0], [6, 1]])
        moves_controller.make_move([5, 0], [6, 0], player_black)
        subject.board.delete_piece([7, 1])
        expect(subject.legal_moves([6, 0], false)).to be_empty
      end
    end
    it 'can capture diagonals from b7 if there is an enemy piece in a6 and c6' do
      subject.board.squares[2][0] = subject.board.squares[7][0]
      subject.board.squares[2][2] = subject.board.squares[7][7]
      expect(subject.legal_moves([1, 1], false)).to match_array([[2, 0], [2, 1], [2, 2], [3, 1]])
    end
  end
  context 'modified boards' do
    let(:subject) { described_class.new(Board.new) }
    describe 'white king can move if there is no initial pawns' do
      it 'returns moves in row 6' do
        subject.board.squares[6].map! { nil }
        expect(subject.legal_moves([7, 4], true)).to match_array([[6, 5], [6, 4], [6, 3]])
      end
    end
    # white
    describe 'white king can castle short if there aren\'t knight and bishop ' do
      it 'returns array with short castle move included [7, 6]' do
        subject.board.squares[7][5] = nil
        subject.board.squares[7][6] = nil
        expect(subject.legal_moves([7, 4], true)).to match_array([[7, 5], [7, 6]])
      end
    end
    describe 'white king can castle long if there aren\'t queen, knight and bishop ' do
      it 'returns array with long castle move included [7, 2]' do
        subject.board.squares[7][1] = nil
        subject.board.squares[7][2] = nil
        subject.board.squares[7][3] = nil
        expect(subject.legal_moves([7, 4], true)).to match_array([[7, 3], [7, 2]])
      end
    end
    describe 'white knight first 2 moves ' do
      it 'returns array with moves in row 5' do
        expect(subject.legal_moves([7, 1], true)).to match_array([[5, 0], [5, 2]])
      end
    end
    describe 'white queen with starts in central square e4 ' do
      it 'returns array with moves to capture and blank squares' do
        subject.board.squares[4][4] = subject.board.squares[7][3]
        subject.board.squares[4][4].square = [4, 4]
        expect(subject.legal_moves([4, 4], true)).to match_array([[1, 1], [1, 4], [1, 7], [2, 2], [2, 4], [2, 6], [3, 3], [3, 4], [3, 5], [4, 0], [4, 1], [4, 2], [4, 3], [4, 5], [4, 6], [4, 7], [5, 3], [5, 4], [5, 5]])
      end
    end
    # black
    describe 'black king can castle short if there aren\'t knight and bishop ' do
      it 'returns array with short castle move included [0, 6]' do
        subject.board.squares[0][5] = nil
        subject.board.squares[0][6] = nil
        expect(subject.legal_moves([0, 4], false)).to match_array([[0, 5], [0, 6]])
      end
    end
    describe 'black king can castle long if there aren\'t queen, knight and bishop ' do
      it 'returns array with long castle move included [0, 2]' do
        subject.board.squares[0][1] = nil
        subject.board.squares[0][2] = nil
        subject.board.squares[0][3] = nil
        expect(subject.legal_moves([0, 4], false)).to match_array([[0, 3], [0, 2]])
      end
    end
    describe 'black knight first 2 moves ' do
      it 'returns array with moves in row 5' do
        expect(subject.legal_moves([0, 1], false)).to match_array([[2, 0], [2, 2]])
      end
    end
  end
  context 'pinned pieces and legal moves' do
    let(:subject) { described_class.new(board) }
    let(:player_white) { Player.new(true) }
    let(:player_black) { Player.new(false) }
    let(:interface) { Interface.new(board, MovesCalculator.new(board)) }
    let(:moves_controller) { MovesController.new(board, interface) }
    describe 'pawn in e2 is pinned because the queen in e7' do
      it 'returns true' do
        queen = subject.board.piece([0, 3])
        subject.board.relocate_piece([1, 4], queen)
        queen.square = [1, 4]
        pawn = subject.board.squares[6][4]
        expect(subject.board.piece([1, 4])).to be_a(Queen)
        expect(subject.under_pin?(pawn, true)).to be_truthy
      end
    end
    describe 'pawn in e2 is not pinned because the queen in e7 ' do
      it 'returns false' do
        queen = subject.board.piece([0, 3])
        pawn_intercepter = subject.board.piece([1, 3])
        subject.board.relocate_piece([5, 4], pawn_intercepter)
        subject.board.relocate_piece([1, 4], queen)
        queen.square = [1, 4]
        pawn = subject.board.squares[6][4]
        expect(subject.under_pin?(pawn, true)).to be_falsy
      end
    end
    describe 'knight is pinned' do
      it 'returns empty legal moves' do
        moves_controller.make_move([0, 3], [1, 4], player_black)
        expect(subject.board.piece([1, 4])).to be_a(Queen)
        moves_controller.make_move([7, 6], [6, 4], player_white)
        expect(subject.board.piece([6, 4])).to be_a(Knight)

        expect(subject.legal_moves([6, 4], true)).to be_empty
      end
    end
    describe 'bishop is pinned' do
      it 'returns empty moves because queen isnt pinning its diagonally' do
        moves_controller.make_move([0, 3], [1, 4], player_black)
        expect(subject.board.piece([1, 4])).to be_a(Queen)
        subject.board.delete_piece([6, 4]) # delete_pawn
        moves_controller.make_move([7, 2], [5, 4], player_white)
        expect(subject.board.piece([5, 4])).to be_a(Bishop)

        expect(subject.legal_moves([5, 4], true)).to be_empty
      end
      it 'returns legal moves only towards queen pinning diagonally from h4' do
        moves_controller.make_move([0, 3], [4, 7], player_black)
        expect(subject.board.piece([4, 7])).to be_a(Queen)
        moves_controller.make_move([7, 2], [6, 5], player_white)
        expect(subject.board.piece([6, 5])).to be_a(Bishop)
        expect(subject.legal_moves([6, 5], true)).to match_array([[5, 6], [4, 7]])
      end
    end
    describe 'queen is pinned' do
      it 'returns legal moves only towards pinner or king' do
        moves_controller.make_move([0, 3], [1, 4], player_black)
        expect(subject.board.piece([1, 4])).to be_a(Queen)
        subject.board.delete_piece([6, 4]) # delete_pawn
        moves_controller.make_move([7, 3], [5, 4], player_white)
        expect(subject.board.piece([5, 4])).to be_a(Queen)

        expect(subject.legal_moves([5, 4], true)).to match_array([[1, 4], [2, 4], [3, 4], [4, 4], [6, 4]])
      end
    end
  end
  context 'under check forced pieces ' do
    let(:subject) { described_class.new(board) }
    let(:player_white) { Player.new(true) }
    let(:player_black) { Player.new(false) }
    let(:interface) { Interface.new(board, MovesCalculator.new(board)) }
    let(:moves_controller) { MovesController.new(board, interface) }
    describe 'forced_pieces after check with queen in e7 ' do
      it 'returns intercepters' do
        moves_controller.make_move([0, 3], [1, 4], player_black)
        expect(subject.board.piece([1, 4])).to be_a(Queen)
        subject.board.delete_piece([6, 4]) # delete_pawn
        expect(subject.under_check?(true)).to be_truthy
        king = subject.board.king(true)
        checker = subject.checker(king)
        expect(checker.square).to match_array([1, 4])
        expect(subject.forced_pieces(king, checker)).to match_array(({[7, 3]=>[[6, 4]], [7, 5]=>[[6, 4]], [7, 6]=>[[6, 4]]}).to_a)
      end

      it 'returns intercepters and defenders(who can attack directly the checker)' do
        moves_controller.make_move([0, 3], [1, 4], player_black)
        moves_controller.make_move([7, 2], [5, 0], player_white)
        expect(subject.board.piece([5, 0])).to be_a(Bishop)
        subject.board.delete_piece([6, 4]) # delete_pawn
        expect(subject.under_check?(true)).to be_truthy
        king = subject.board.king(true)
        checker = subject.checker(king)
        expect(checker.square).to match_array([1, 4])
        expect(subject.forced_pieces(king, checker).to_a).to match_array([[[5, 0], [1, 4]], [[7, 3], [[6, 4]]], [[7, 5], [[6, 4]]], [[7, 6], [[6, 4]]]])
      end
    end
  end
end

