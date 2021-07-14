require_relative 'piece'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'pawn'
require_relative 'king'
require_relative 'colorize'

class Board
  attr_accessor :squares

  def initialize
    @squares = Array.new(8) { Array.new(8, nil) }
    init_black
    init_white
  end

  def init_white
    @squares[7] = [Rook.new([7, 0], 'white'),
                   Knight.new([7, 1], 'white'),
                   Bishop.new([7, 2], 'white'),
                   Queen.new([7, 3], 'white'),
                   King.new([7, 4], 'white'),
                   Bishop.new([7, 5], 'white'),
                   Knight.new([7, 6], 'white'),
                   Rook.new([7, 7], 'white')]
    @squares[6].map!.with_index { |_, idx| Pawn.new([6, idx], 'white') }
  end

  def init_black
    @squares[0] = [Rook.new([0, 0], 'black'),
                   Knight.new([0, 1], 'black'),
                   Bishop.new([0, 2], 'black'),
                   Queen.new([0, 3], 'black'),
                   King.new([0, 4], 'black'),
                   Bishop.new([0, 5], 'black'),
                   Knight.new([0, 6], 'black'),
                   Rook.new([0, 7], 'black')]
    @squares[1].map!.with_index { |_, idx| Pawn.new([1, idx], 'black') }
  end

  def move_piece!(piece, from_square, to_square)
    @squares[to_square[0]][to_square[1]] = piece
    @squares[from_square[0]][from_square[1]] = nil
  end

  def capture_piece!
    
  end

  def display_board
    counter = 0
    @squares.each_with_index do |row, idx_row|
      print (idx_row - 8).abs," "
      row.each_with_index do |square, idx_square|
          if square.nil?
            print "   ".bg_gray if counter.even?
            print "   ".bg_black if counter.odd?
         
          else
             print " #{square.unicode}".bg_gray if counter.even?
             print " #{square.unicode}".bg_black if counter.odd?
          end
          counter += 1 unless idx_square == 7
          
      end
      print "\n"
    end
    print "   a  b  c  d  e  f  g  h \n"
    
  end


end

board = Board.new

board.move_piece! Pawn.new([0,0], "white"), [6,0], [5,0]
board.display_board

#board.move_piece! Pawn.new([0,0], "white"), [5,0], [4,0]
#board.display_board
