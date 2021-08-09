# frozen_string_literal: true

class King < Piece
  attr_accessor :right_rook, :left_rook

  def initialize(square, is_white, left_rook, right_rook)
    super(square, is_white)
    @left_rook = left_rook
    @right_rook = right_rook
  end

  def moves(board, attacked_squares, checker = false)
    if checker
      xrayed = xrayed(board, checker)
      normal_moves(board, attacked_squares).reject { |move| xrayed.include?(move) }
    else
      normal_moves(board, attacked_squares) + castle_moves(board, attacked_squares)
    end
  end

  def normal_moves(board, attacked_squares)
    around_squares.select { |move| valid_move?(move, board, attacked_squares) }
  end

  def valid_move?(move, board, attacked_squares)
    return false if attacked_squares.include?(move)

    if encounter_piece?(board, move)
      can_capture?(board, move)
    else
      true # it's a free square
    end
  end

  def attacked_square?(board, move)
    board.player_attacked_squares(color == 'white' ? 'black' : 'white').include?(move) 
  end

  def xrayed(board, checker)
    return [] if %w[Pawn Knight].include?(checker.class.to_s)

    board = board.clone
    board.squares = board.squares.map { |row| row.map { |square| square == self ? nil : square } }
    checker.legal_moves(board, false, 'Hash').each_value { |value| return value if value.include?(self.square) }
  end

  def around_squares
    moves_vector = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
    moves_vector.map { |y, x| [square[0] + y, square[1] + x] }.select { |move| within_board?(move) }
  end

  def castle_moves(board, attacked_squares, castle_moves = [])
    return castle_moves if moved

    if is_white
      castle_moves << [7, 6] if can_short_castle?(board, attacked_squares)
      castle_moves << [7, 2] if can_long_castle?(board, attacked_squares)
    else
      castle_moves << [0, 6] if can_short_castle?(board, attacked_squares)
      castle_moves << [0, 2] if can_long_castle?(board, attacked_squares)
    end
    castle_moves
  end

  def can_short_castle?(board, attacked_squares)
    return false if right_rook.moved

    between_coordinates = is_white ? [[7, 5], [7, 6]] : [[0, 5], [0, 6]]
    safe_squares?(between_coordinates, attacked_squares) && free_squares?(board, between_coordinates)
  end

  def can_long_castle?(board, attacked_squares)
    return false if left_rook.moved

    between_coordinates = is_white ? [[7, 1], [7, 2], [7, 3]] : [[0, 1], [0, 2], [0, 3]]
    safe_squares?(between_coordinates, attacked_squares) && free_squares?(board, between_coordinates)
  end

  def safe_squares?(coordinates, attacked_squares)
    (attacked_squares & coordinates).empty?
  end

  def free_squares?(board, coordinates)
    coordinates.all? { |coordinate| board.piece(coordinate).nil? }
  end

  def unicode
    is_white ? '♔ '.magenta : '♚ '.yellow
  end
end