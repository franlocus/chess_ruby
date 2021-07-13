class King < Piece
  
  def legal_moves
    moves_vector = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
    moves_vector
      .map { |y, x| [square[0] + y, square[1] + x] }
      .keep_if { |move| move[0].between?(0, 7) && move[1].between?(0, 7) }
  end
  
  def unicode
    @color == "white" ? "♔" : "♚" 
  end
  
end