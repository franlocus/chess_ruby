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
    init_black
    init_white
  end

  def init_white
    @squares[-1] = [Rook.new([7, 0], 'white'),
                    Knight.new([7, 1], 'white'),
                    Bishop.new([7, 2], 'white'),
                    Queen.new([7, 3], 'white'),
                    King.new([7, 4], 'white'),
                    Bishop.new([7, 5], 'white'),
                    Knight.new([7, 6], 'white'),
                    Rook.new([7, 7], 'white')]
    @squares[-2].map!.with_index { |_, idx| Pawn.new([6, idx], 'white') }
  end

  def init_black
    @squares[0] = [Rook.new([7, 0], 'black'),
                   Knight.new([7, 1], 'black'),
                   Bishop.new([7, 2], 'black'),
                   Queen.new([7, 3], 'black'),
                   King.new([7, 4], 'black'),
                   Bishop.new([7, 5], 'black'),
                   Knight.new([7, 6], 'black'),
                   Rook.new([7, 7], 'black')]
    @squares[1].map!.with_index { |_, idx| Pawn.new([1, idx], 'black') }
  end

  def move_piece!

    
  end

  def capture_piece!
    
  end

  def display_board
    @squares.each do |row|
      row.each do |square|
          if square.nil?
            print " __|"
          else
             print " #{square.unicode} |"
          end
      end
      print "\n"
    end
  end


end

board = Board.new
board.display_board
