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
    @squares = generate_squares
    setup_pieces
  end

  def generate_squares
    Array.new(8) { Array.new(8, nil) }.map.with_index do |row, idx_row|
      row.map.with_index { |_, col_idx| Square.new(idx_row, col_idx) }
    end
  end

  def setup_pieces
    mayors('white', 7)
    pawns('white', 6)
    mayors('black', 0)
    pawns('black', 1)
  end

  def mayors(color, row)
    @squares[row].each_with_index do |square, idx|
      square.piece =  case idx
                      when 0 then Rook.new(color)
                      when 1 then Knight.new(color)
                      when 2 then Bishop.new(color)
                      when 3 then Queen.new(color)
                      when 4 then King.new(color)
                      when 5 then Bishop.new(color)
                      when 6 then Knight.new(color)
                      else Rook.new(color)
                      end
    end
  end

  def pawns(color, row)
    @squares[row].each { |square| square.piece = Pawn.new(color) }
  end
end


class NilClass
  def unicode
   '  '
  end
end
