class Bishop < Piece

  def legal_moves
    moves_vector = [[-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
                    [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7],
                    [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
                    [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]]
    moves_vector
      .map { |y, x| [square[0] + y, square[1] + x] }
      .keep_if { |move| move[0].between?(0, 7) && move[1].between?(0, 7) }
  end

  def unicode
    @color == "white" ? "♗ ".cyan : "♝ ".yellow 
  end
  
end