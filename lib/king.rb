# frozen_string_literal: true

class King < Piece
  def legal_moves(board, defence_move = false)
    moves_vector = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
    moves_vector.map { |y, x| [square[0] + y, square[1] + x] }.select { |move| valid_move?(move, board) }
  end

  def valid_move?(move, board)
    move.all? { |n| n.between?(0, 7) } &&
      (!board.piece?(move) || board.enemy_piece?(move, color)) &&
      !board.defended_squares_by(@color == 'white' ? 'black' : 'white').include?(move)
  end

  def unicode
    @color == "white" ? "♔ ".magenta : "♚ ".yellow 
  end
end