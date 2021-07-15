class Rook < Piece

  def legal_moves
    moves_vector = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
                    [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
                    [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0],
                    [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7]]
    moves_vector
      .map { |y, x| [square[0] + y, square[1] + x] }
      .keep_if { |move| move[0].between?(0, 7) && move[1].between?(0, 7) }
  end

  def unicode
    @color == "white" ? "♖ ".cyan : "♜ ".yellow  
  end
  
end