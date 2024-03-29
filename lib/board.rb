# frozen_string_literal: true

require_relative 'square'
require_relative 'piece'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'pawn'
require_relative 'king'

class Board
  attr_accessor :squares, :history_moves

  def initialize
    @squares = Array.new(8) { Array.new(8, nil) }
    @history_moves = []
    setup_pieces
  end

  def setup_pieces
    mayors(true, 7)
    rooks_to_kings(true, 7)
    pawns(true, 6)
    mayors(false, 0)
    pawns(false, 1)
    rooks_to_kings(false, 0)
  end

  def rooks_to_kings(is_white, row)
    left_rook = piece([row, 0])
    right_rook = piece([row, 7])
    squares[row][4] = King.new(is_white, [row, 4], left_rook, right_rook)
  end

  def mayors(is_white, row)
    squares[row].map!.with_index do |_, idx|
      case idx
      when 0 then Rook.new(is_white, [row, idx])
      when 1 then Knight.new(is_white, [row, idx])
      when 2 then Bishop.new(is_white, [row, idx])
      when 3 then Queen.new(is_white, [row, idx])
      when 5 then Bishop.new(is_white, [row, idx])
      when 6 then Knight.new(is_white, [row, idx])
      else Rook.new(is_white, [row, idx])
      end
    end
  end

  def pawns(is_white, row)
    squares[row].map!.with_index { |_, idx| Pawn.new(is_white, [row, idx]) }
  end

  def piece(coordinates)
    squares[coordinates.first][coordinates.last]
  end

  def delete_piece(coordinates)
    squares[coordinates.first][coordinates.last] = nil
  end

  def relocate_piece(coordinates, piece)
    squares[coordinates.first][coordinates.last] = piece
  end

  def king(is_white)
    squares.flatten.find { |piece| piece.is_a?(King) && piece.is_white == is_white }
  end
end

