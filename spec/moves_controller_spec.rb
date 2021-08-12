# frozen_string_literal: true

require_relative '../lib/moves_calculator'
require_relative '../lib/moves_controller'
require_relative '../lib/board'
require_relative '../lib/interface'
require_relative '../lib/player'
require_relative '../lib/colorize'

describe MovesController do
  let(:board) { Board.new }
  let(:player_white) { Player.new(true) }
  let(:player_black) { Player.new(false) }
  let(:interface) { Interface.new(board, MovesCalculator.new(board) , player_white, player_black) }
  let(:subject) { described_class.new(board, interface) }
  describe '#make_move' do
    let(:player_white) { Player.new(true) }
    let(:player_black) { Player.new(false) }
    context 'castle moves' do
      it 'detects white castle_move? and move king and rook' do
        board = subject.board
        board.squares[7][5] = nil
        board.squares[7][6] = nil
        subject.make_move([7, 4], [7, 6], player_white)
        expect(board.piece([7, 4])).to be_nil
        expect(board.piece([7, 7])).to be_nil
        expect(board.piece([7, 6])).to satisfy { |piece| be_a(King) && (piece.square == [7, 6]) }
        expect(board.piece([7, 5])).to satisfy { |piece| be_a(Rook) && (piece.square == [7, 5]) }
      end
    end
    context 'pawn en passant' do
      it 'detects pawn en passant movement, make move and update score' do
        board = subject.board
        score_before = player_white.score.clone
        subject.make_move([6, 4], [3, 4], player_white)
        subject.make_move([1, 3], [3, 3], player_black)
        pawn_capturing = board.piece([3, 4])
        pawn_capturing.instance_variable_set(:@en_passant, [[2, 3]])
        subject.make_move([3, 4], [2, 3], player_white)
        expect(pawn_capturing).to satisfy { |piece| be_a(Pawn) && (piece.square == [2, 3])} 
        score_after = player_white.score
        expect(score_before).not_to eq(score_after)
        square_eaten_pawn = board.piece([3, 3])
        expect(square_eaten_pawn).to be_nil
        
      end
    end

    context 'pawn promotion' do
      before do
        allow(interface).to receive(:puts)
        valid_input = '1'
        allow(interface).to receive(:gets).and_return(valid_input)
      end
      it 'prompt the user for select a piece to promote, input 1 and promote a Queen' do
        board = subject.board
        board.squares[0][0] = nil
        board.squares[1][0] = nil
        subject.make_move([6, 4], [1, 0], player_white)
        subject.make_move([1, 0], [0, 0], player_white)
        expect(board.piece([0, 0])).to satisfy { |piece| be_a(Queen) && (piece.square == [0, 0])} 
      end
    end

    context 'normal move' do
      it 'moves piece from one square to another' do
        board = subject.board
        pawn_before = board.piece([6, 4]).square
        subject.make_move([6, 4], [4, 4], player_white)
        pawn_after = board.piece([4, 4]).square
        expect(pawn_before).not_to eq(pawn_after)
        expect(board.piece([6, 4])).to be_nil
      end
    end
    context 'capture move updates player_white score' do
      it 'moves piece from one square to another' do
        board = subject.board
        board.squares[5][4] = Queen.new(false, [5, 4])
        score_before = player_white.score.clone
        subject.make_move([6, 5], [5, 4], player_white)
        score_after = player_white.score
        expect(score_before).not_to eq(score_after)
      end
    end
  end
end

