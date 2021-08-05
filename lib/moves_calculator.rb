# frozen_string_literal: true

class MovesCalculator
  attr_reader :board
  
  def initialize(board)
    @board = board
  end

  def legal_moves(coordinates)
    piece = board.piece(coordinates)
    piece.moves(board)
  end

  def legal_moves2(coordinates, player, checker = nil)
    piece = fetch_piece(coordinates)
    if under_pin?(piece, player.king, checker)
      return [] if piece.is_a?(Knight)

      pinned_fireline(piece, player.king, checker) & piece.legal_moves(@board)
    else
      piece.legal_moves(@board)
    end
  end
end