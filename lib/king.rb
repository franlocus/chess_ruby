# frozen_string_literal: true

class King < Piece
  attr_accessor :right_rook, :left_rook

  def initialize(square, is_white, left_rook, right_rook)
    super(square, is_white)
    @left_rook = left_rook
    @right_rook = right_rook
  end

  def moves(board, preventive_move = false, checker = false)
    if checker
      xrayed = xrayed(board, checker)
      normal_moves(board, preventive_move).reject { |move| xrayed.include?(move) }
    else
      normal_moves(board, preventive_move) + castle_moves(board)
    end
  end

  def normal_moves(board, preventive_move)
    bordering_squares.select { |move| valid_move?(move, board, preventive_move) }
  end

  def valid_move?(move, board, preventive_move)
    #return false if attacked_square?(board, move)

    if encounter_piece?(board, move)
      preventive_move || can_capture?(board, move)
    else
      true # it's a free square
    end
  end

  def attacked_square?(board, move)
    board.defended_squares_by(color == 'white' ? 'black' : 'white').include?(move) 
  end

  def xrayed(board, checker)
    return [] if %w[Pawn Knight].include?(checker.class.to_s)

    board = board.clone
    board.squares = board.squares.map { |row| row.map { |square| square == self ? nil : square } }
    checker.legal_moves(board, false, 'Hash').each_value { |value| return value if value.include?(self.square) }
  end

  def bordering_squares
    moves_vector = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
    moves_vector.map { |y, x| [square[0] + y, square[1] + x] }.select { |move| within_board?(move) }
  end

  def castle_moves(board)
    castle_moves = []
    if is_white
      castle_moves << [7, 6] if can_short_castle?(board)
      castle_moves << [7, 2] if can_long_castle?(board)
    else
      castle_moves << [0, 6] if can_short_castle?(board)
      castle_moves << [0, 2] if can_long_castle?(board)
    end
    castle_moves
  end

  def can_short_castle?(board)
    if is_white
      short_castle?(board, 7, 'black', [[7, 5], [7, 6]], right_rook)
    else
      short_castle?(board, 0, 'white', [[0, 5], [0, 6]], right_rook)
    end
  end

  def can_long_castle?(board)
    if is_white
      long_castle?(board, 7, 'black', [[7, 1], [7, 2], [7, 3]], left_rook)
    else
      long_castle?(board, 0, 'white', [[0, 1], [0, 2], [0, 3]], left_rook)
    end
  end

  def short_castle?(board, row, enemy, coordinates, rook)
    return false if moved

    !rook.moved && board.squares[row][5..6].compact.empty? &&
      (board.defended_squares_by(enemy) & coordinates).empty?
  end

  def long_castle?(board, row, enemy, coordinates, rook)
    return false if moved

    !rook.moved && board.squares[row][1..3].compact.empty? &&
      (board.defended_squares_by(enemy) & coordinates).empty?
  end
  
  def unicode
    is_white ? '♔ '.magenta : '♚ '.yellow
  end
end