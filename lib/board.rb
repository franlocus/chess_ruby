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
  attr_accessor :squares

  def initialize
    @squares = Array.new(8) { Array.new(8, nil) }
    setup_pieces
  end

  # def generate_squares
  #  Array.new(8) { Array.new(8, nil) }.map.with_index do |row, idx_row|
  #    row.map.with_index { |_, col_idx| Square.new(idx_row, col_idx) }
  #  end
  # end

  def setup_pieces
    mayors('white', 7)
    #pawns('white', 6)
    mayors('black', 0)
    pawns('black', 1)
  end

  def mayors(color, row)
    @squares[row].map!.with_index do |_, idx|
      case idx
      when 0 then Rook.new(color, [row, idx])
      when 1 then Knight.new(color, [row, idx])
      when 2 then Bishop.new(color, [row, idx])
      when 3 then Queen.new(color, [row, idx])
      when 4 then King.new(color, [row, idx])
      when 5 then Bishop.new(color, [row, idx])
      when 6 then Knight.new(color, [row, idx])
      else Rook.new(color, [row, idx])
      end
    end
  end

  def pawns(color, row)
    @squares[row].map!.with_index { |_, idx| Pawn.new(color, [row, idx]) }
  end

  def player_piece?(coordinates, player_color)
    selected_piece = squares.flatten.find { |square| square.y == coordinates[0] && square.x == coordinates[1] }.piece
    selected_piece.color == player_color unless selected_piece.nil?
  end

  def piece(coordinates)
    squares[coordinates.first][coordinates.last]
  end
end

class NilClass
  def unicode
    '  '
  end
end
