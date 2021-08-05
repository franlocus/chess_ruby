# frozen_string_literal: true

class Knight < Piece
  def moves(board, preventive_move = false, _ = false)
    moves_vector = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
    moves_vector.map { |y, x| [square[0] + y, square[1] + x] }.select { |move| valid_move?(move, board, preventive_move) }
  end

  def valid_move?(move, board, preventive_move)
    within_board?(move) &&
      ((!board.piece?(move) || board.enemy_piece?(move, color)) || (board.piece?(move) && preventive_move))
  end

  def unicode
    @color == "white" ? "♘ ".magenta : "♞ ".yellow 
  end
end
