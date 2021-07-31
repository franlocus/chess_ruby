# frozen_string_literal: true

require_relative '../lib/square'

class Board
  attr_accessor :board

  def initialize
    @board = generate_squares
  end

  def generate_squares
    Array.new(8) { Array.new(8, nil) }.map.with_index do |row, idx_row|
      row.map.with_index { |_, col_idx| Square.new(idx_row, col_idx) }
    end
  end

  def display
    @board.each_with_index do |row, idx_row|
      print (idx_row - 8).abs, ' '
      row.each do |square|
        print square.bg_color == 'black' ? '  '.bg_black : '  '.bg_gray
      end
      print "\n"
    end
    print "  a b c d e f g h \n"
  end
end