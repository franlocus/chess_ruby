# frozen_string_literal: true

class Knight < Piece
  def moves(board, preventive_move = false, _ = false)
    moves_vector = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
    moves_vector.map { |y, x| [square[0] + y, square[1] + x] }.select { |move| valid_move?(move, board, preventive_move) }
  end

  def valid_move?(move, board, preventive_move)
    return false unless within_board?(move)

    if encounter_piece?(board, move)
      preventive_move || can_capture?(board, move)
    else
      true # it's a free square
    end
  end

  def unicode
    @color == "white" ? "♘ ".magenta : "♞ ".yellow 
  end
end
