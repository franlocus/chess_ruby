# frozen_string_literal: true

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
    setup_black
    setup_white
    @squares[5][5] = Queen.new([5, 5], 'black')
    @squares[2][2] = Queen.new([2, 2], 'white')
  end

  def setup_white
    @squares[7] = [Rook.new([7, 0], 'white'),
                   Knight.new([7, 1], 'white'),
                   Bishop.new([7, 2], 'white'),
                   Queen.new([7, 3], 'white'),
                   King.new([7, 4], 'white'),
                   Bishop.new([7, 5], 'white'),
                   Knight.new([7, 6], 'white'),
                   Rook.new([7, 7], 'white')]
    @squares[6].map!.with_index { |_, idx| Pawn.new([6, idx], 'black') }
  end

  def setup_black
    @squares[0] = [nil,
                   Knight.new([0, 1], 'black'),
                   Bishop.new([0, 2], 'black'),
                   Queen.new([0, 3], 'black'),
                   King.new([0, 4], 'black'),
                   Bishop.new([0, 5], 'black'),
                   Knight.new([0, 6], 'black'),
                   Rook.new([0, 7], 'black')]
    @squares[1].map!.with_index { |_, idx| Pawn.new([1, idx], 'white') }
  end

  def piece?(coordinates)
    !@squares[coordinates.first][coordinates.last].nil?
  end

  def fetch_piece(coordinates)
    @squares[coordinates.first][coordinates.last]
  end

  def enemy_piece?(coordinates, caller_color)
    return false unless coordinates.all? { |n| n.between?(0, 7) }

    square_to_check = @squares[coordinates.first][coordinates.last]
    if square_to_check.nil?
      false
    else
      square_to_check.color != caller_color
    end
  end

  def legal_moves(coordinates)
    @squares[coordinates.first][coordinates.last].legal_moves(self)
  end

  def attacked_squares_by(player_color)
    attacked_squares = []
    @squares.each do |row|
      row.each do |square|
        next if square.nil? || square.color != player_color

        attacked_squares += square.legal_moves(self)
      end
    end
    attacked_squares
  end

  def move_piece!(from_square, to_square, piece)
    @squares[from_square.first][from_square.last] = nil
    @squares[to_square.first][to_square.last] = piece
    piece.has_moved = true
  end

  def promote_pawn(from_square, to_square, color, promoted_piece)
    @squares[from_square.first][from_square.last] = nil
    @squares[to_square.first][to_square.last] = case promoted_piece
                                                when '1' then Queen.new(to_square, color)
                                                when '2' then Rook.new(to_square, color)
                                                when '3' then Bishop.new(to_square, color)
                                                else Knight.new(to_square, color)
                                                end
  end
end #endclass

class NilClass
  def unicode
    "  "
  end
end
