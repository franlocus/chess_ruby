# frozen_string_literal: true

require_relative 'piece'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'pawn'
require_relative 'king'

class Board
  attr_accessor :squares, :white_king, :black_king

  def initialize
    @squares = Array.new(8) { Array.new(8, nil) }
    setup_black
    setup_white
    @squares[5][6] = Queen.new([5, 6], 'white')
    @squares[3][2] = Queen.new([3, 2], 'white')
    @squares[1][3] = Knight.new([1, 3], 'white')
  end

  def setup_white
    @white_king = King.new([7, 4], 'white')
    @squares[7] = [Rook.new([7, 0], 'white'),
                   Knight.new([7, 1], 'white'),
                   Bishop.new([7, 2], 'white'),
                   Queen.new([7, 3], 'white'),
                   @white_king,
                   Bishop.new([7, 5], 'white'),
                   Knight.new([7, 6], 'white'),
                   Rook.new([7, 7], 'white')]
    @squares[6].map!.with_index { |_, idx| Pawn.new([6, idx], 'white') }
  end

  def setup_black
    @black_king = King.new([0, 4], 'black')
    @squares[0] = [nil,
                   Knight.new([0, 1], 'black'),
                   Bishop.new([0, 2], 'black'),
                   Queen.new([0, 3], 'black'),
                   @black_king,
                   Bishop.new([0, 5], 'black'),
                   Knight.new([0, 6], 'black'),
                   Rook.new([0, 7], 'black')]
    #@squares[1].map!.with_index { |_, idx| Pawn.new([1, idx], 'black') }
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
    square_to_check.nil? ? false : square_to_check.color != caller_color
  end

  def legal_moves(coordinates)
    @squares[coordinates.first][coordinates.last].legal_moves(self)
  end

  def defended_squares_by(player_color)
    attacked_squares = []
    @squares.each do |row|
      row.each do |square|
        next if square.nil? || square.color != player_color 

        attacked_squares += square.is_a?(King) ? square.bordering_squares : square.legal_moves(self, true)
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

  def under_check?(player_color)
    attacked_squares = defended_squares_by(player_color == 'white' ? 'black' : 'white')
    attacked_squares.include?(player_color == 'white' ? @white_king.square : @black_king.square)
  end

  def fetch_checker(king)
    checker = []
    @squares.each do |row|
      row.each do |square|
        next if square.nil? || !square.legal_moves(self).include?(king.square)

        checker << square
      end
    end
    checker.size == 1 ? checker.first : double_check
  end

  def double_check
    "DOUBLE CHECK"
  end

  # move king, attack attacker, intercept attacker)
  def forced_pieces(king)
    checker = fetch_checker(king)
    defenders = defenders(checker, king)
    intercepters = intercepters(checker, king)
    pieces = defenders.merge(intercepters)
    pieces[king.square] = king.legal_moves(self)
    pieces
  end

  def defenders(checker, king)
    defenders = {}
    @squares.each do |row|
      row.each do |square|
        next if square.nil? || square.color != king.color

        defenders[square.square] = checker.square if square.legal_moves(self).include?(checker.square)
      end
    end
    defenders
  end

  def intercepters(checker, king, intercepter = {})
    fire_line = search_fireline(checker, king.square)
    @squares.each do |row|
      row.each do |square|
        next if square.nil? || square.color != king.color

        unless (square.legal_moves(self) & fire_line).empty?
          intercepter[square.square] = (square.legal_moves(self) & fire_line)
        end
      end
    end
    intercepter
  end

  def search_fireline(checker, king_square)
    return [] if %w[Pawn Knight King].include?(checker.class.to_s)

    checker.legal_moves(self, false, 'Hash').each_value { |value| return value if value.include?(king_square) }
  end
end #endclass

class NilClass
  def unicode
    "  "
  end
end
