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
    setup_mayor_pieces('white', 7)
  end

  def generate_squares
    Array.new(8) { Array.new(8, nil) }.map.with_index do |row, idx_row|
      row.map.with_index { |_, col_idx| Square.new(idx_row, col_idx) }
    end
  end

  def setup_mayor_pieces(color, row)
    @squares[row][0].piece = Rook.new(color)
    @squares[row][1].piece = Knight.new(color)
    @squares[row][2].piece = Knight.new(color)
    @squares[row][3].piece = Knight.new(color)
    @squares[row][4].piece = Knight.new(color)
    @squares[row][5].piece = Knight.new(color)
    @squares[row][6].piece = Knight.new(color)
    @squares[row][7].piece = Knight.new(color)
  end

  def display
    @squares.each_with_index do |row, idx_row|
      print (idx_row - 8).abs, ' '
      row.each do |square|
        print square.bg_color == 'black' ? '  '.bg_black : '  '.bg_gray
      end
      print "\n"
    end
    print "  a b c d e f g h \n"
  end
end