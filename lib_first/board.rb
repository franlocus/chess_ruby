# frozen_string_literal: true

class Board
  attr_accessor :squares, :player_white, :player_black

  def initialize(player_white, player_black)
    @squares = Array.new(8) { Array.new(8, nil) }
    @player_white = player_white
    @player_black = player_black
    setup_white
    setup_black
  end

  def setup_white
    left_rook = Rook.new([7, 0], 'white')
    right_rook = Rook.new([7, 7], 'white')
    @player_white.king = King.new([7, 4], 'white', left_rook, right_rook)
    @squares[7] = [left_rook,
                   Knight.new([7, 1], 'white'),
                   Bishop.new([7, 2], 'white'),
                   Queen.new([7, 3], 'white'),
                   @player_white.king,nil,nil,
                   #Bishop.new([7, 5], 'white'),
                   #Knight.new([7, 6], 'white'),
                   right_rook]
    @squares[6].map!.with_index { |_, idx| Pawn.new([6, idx], 'white') }
  end

  def setup_black
    left_rook = Rook.new([0, 0], 'black')
    right_rook = Rook.new([0, 7], 'black')
    @player_black.king = King.new([0, 4], 'black', left_rook, right_rook)
    @squares[0] = [left_rook,
                   Knight.new([0, 1], 'black'),
                   Bishop.new([0, 2], 'black'),
                   Queen.new([0, 3], 'black'),
                   @player_black.king,
                   Bishop.new([0, 5], 'black'),
                   Knight.new([0, 6], 'black'),
                   right_rook]
    @squares[1].map!.with_index { |_, idx| Pawn.new([1, idx], 'black') }
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

  def legal_moves(coordinates, player, checker = nil)
    piece = fetch_piece(coordinates)
    if under_pin?(piece, player.king, checker)
      return [] if piece.is_a?(Knight)

      pinned_fireline(piece, player.king, checker) & piece.legal_moves(self)
    else
      piece.legal_moves(self)
    end
  end

  def defended_squares_by(player_color)
    defended = []
    @squares.each do |row|
      row.each do |square|
        next if square.nil? || square.color != player_color 

        defended += square.is_a?(King) ? square.bordering_squares : square.legal_moves(self, true)
      end
    end
    defended
  end

  def move_piece!(from_square, to_square, piece)
    @squares[from_square.first][from_square.last] = nil
    @squares[to_square.first][to_square.last] = piece
    piece.has_moved = true
  end

  def under_check?(player)
    attacked_squares = defended_squares_by(player.color == 'white' ? 'black' : 'white')
    attacked_squares.include?(player.king.square)
  end

  def fetch_checker(king, board = self, checker = false)
    board.squares.each do |row|
      row.each do |square|
        next if square.nil? || !square.legal_moves(board).include?(king.square)

        return square unless square == checker
      end
    end
    nil
  end

  def forced_pieces(king, checker)
    pieces = check_blockers(checker, king)
    pieces[king.square] = king.legal_moves(self, false, checker) unless king.legal_moves(self, false, checker).empty?
    pieces.reject { |piece_square| under_pin?(fetch_piece(piece_square), king, checker) }
  end

  def check_blockers(checker, king)
    defenders = defenders(checker, king)
    intercepters = intercepters(checker, king)
    defenders.merge(intercepters) do |_key, defender_val, intercepter_val|
      defender_val = [defender_val] unless defender_val.any?(Array)
      intercepter_val = [intercepter_val] unless intercepter_val.any?(Array)
      defender_val + intercepter_val
    end
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
    return [] if %w[Pawn Knight].include?(checker.class.to_s)

    checker.legal_moves(self, false, 'Hash').each_value { |value| return value if value.include?(king_square) }
  end

  def under_pin?(piece, king, checker)
    return false if piece.is_a?(King)

    board = clone
    board.squares = board.squares.map { |row| row.map { |square| square == piece ? nil : square } }
    fetch_checker(king, board, checker).nil? ? false : true
  end

  def fetch_pinner(piece, king, checker)
    board = clone
    board.squares = board.squares.map { |row| row.map { |square| square == piece ? nil : square } }
    fetch_checker(king, board, checker)
  end

  def pinned_fireline(piece, king, checker)
    pinner = fetch_pinner(piece, king, checker)
    moves = []
    pinner.legal_moves(self, false, 'Hash').each_value { |value| moves += value if value.include?(piece.square) }
    unless piece.is_a?(Pawn)
      piece.legal_moves(self, true, 'Hash').each_value { |value| moves += value if value.include?(king.square) }
      moves.delete(king.square)
    end
    moves.delete(piece.square)
    moves << pinner.square
  end
end #endclass

class NilClass
  def unicode
    "  "
  end
end