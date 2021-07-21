# frozen_string_literal: true

class Knight < Piece
  def legal_moves(board, defence_move = false)
    moves_vector = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
    moves_vector.map { |y, x| [square[0] + y, square[1] + x] }.select { |move| valid_move?(move, board) }
  end

  def valid_move?(move, board)
    move.all? { |n| n.between?(0, 7) } && (!board.piece?(move) || board.enemy_piece?(move, color))
  end

  def unicode
    @color == "white" ? "♘ ".magenta : "♞ ".yellow 
  end

end