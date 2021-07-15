class Pawn < Piece

  def setup_vectors
    moves_vector = @color == "white" ? [[-1, 0]]  : [[1, 0]]
    unless @has_moved
      @color == "white" ?  moves_vector.push([-2, 0]) : moves_vector.push([2, 0])
    end
    @has_moved ||= true
    moves_vector
  end

  def legal_moves
    setup_vectors
      .map { |y, x| [square[0] + y, square[1] + x] }
      .keep_if { |move| move[0].between?(0, 7) && move[1].between?(0, 7) }
  end

  def unicode
    @color == "white" ? "♙ ".cyan : "♟︎ ".yellow 
  end
  
end