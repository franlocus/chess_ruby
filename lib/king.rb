# frozen_string_literal: true

class King < Piece

  def initialize(square, color, left_rook, right_rook)
    super(square, color)
    @left_rook = left_rook
    @right_rook = right_rook
  end

  def legal_moves(board, defence_move = false, checker = false)
    if checker
      xrayed = xrayed(board, checker)
      normal_legal_moves(board, defence_move).reject { |move| xrayed.include?(move) }
    else
      normal_legal_moves(board, defence_move) + castle_moves(board)
    end
  end

  def normal_legal_moves(board, defence_move)
    moves_vector = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
    moves_vector.map { |y, x| [square[0] + y, square[1] + x] }.select { |move| valid_move?(move, board, defence_move) }
    # add castle moves
  end

  def valid_move?(move, board, defence_move)
    within_board?(move) &&
      !board.defended_squares_by(@color == 'white' ? 'black' : 'white').include?(move) &&
      ((!board.piece?(move) || board.enemy_piece?(move,  @color)) || (defence_move && board.piece?(move)))
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
    if color == 'white'
      castle_moves << [7, 6] if can_short_castle?(board)
      castle_moves << [7, 2] if can_long_castle?(board)
    else
      castle_moves << [0, 6] if can_short_castle?(board)
      castle_moves << [0, 2] if can_long_castle?(board)
    end
    castle_moves
  end

  def can_short_castle?(board)
    if color == 'white'
      short_castle?(board, 7, 'black', [[7, 5], [7, 6]], @right_rook)
    else
      short_castle?(board, 0, 'white', [[0, 5], [0, 6]], @right_rook)
    end
  end

  def can_long_castle?(board)
    if color == 'white'
      long_castle?(board, 7, 'black', [[7, 1], [7, 2], [7, 3]], @left_rook)
    else
      long_castle?(board, 0, 'white', [[0, 1], [0, 2], [0, 3]], @left_rook)
    end
  end

  def short_castle?(board, row, enemy, coordinates, rook)
    return false if @has_moved

    !rook.has_moved && board.squares[row][5..6].compact.empty? &&
      (board.defended_squares_by(enemy) & coordinates).empty?
  end

  def long_castle?(board, row, enemy, coordinates, rook)
    return false if @has_moved

    !rook.has_moved && board.squares[row][1..3].compact.empty? &&
      (board.defended_squares_by(enemy) & coordinates).empty?
  end

  def unicode
    @color == "white" ? "♔ ".magenta : "♚ ".yellow 
  end
end


#no se ha movido ni rey ni rook
#no under check, ni attacked squares al pasar o terminar
#que no haya pieza en el medio