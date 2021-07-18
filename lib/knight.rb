# frozen_string_literal: true

class Knight < Piece

  def legal_moves(board)
    moves_vector = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
    moves_vector
      .map { |y, x| [square[0] + y, square[1] + x] }
      .keep_if do |move|
        move[0].between?(0, 7) && move[1].between?(0, 7) &&
          (!board.piece?(move) || board.enemy_piece?(move, color))
      end
  end

  def unicode
    @color == "white" ? "♘ ".magenta : "♞ ".yellow 
  end
  
end

 
