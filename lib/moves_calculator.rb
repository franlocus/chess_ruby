# frozen_string_literal: true

class MovesCalculator
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def legal_moves(coordinates, is_white)
    piece = board.piece(coordinates)
    if piece.is_a?(King)
      piece.moves(board, player_attacked_squares(!is_white))
    else
      piece.moves(board)
    end
  end

  def player_attacked_squares(is_white)
    attacked = []
    board.squares.each do |row|
      row.each do |square|
        next if square.nil? || square.is_white != is_white

        attacked += square.is_a?(King) ? square.around_squares : square.moves(board, true)
      end
    end
    attacked
  end

# TODO: UNDER pin? 
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