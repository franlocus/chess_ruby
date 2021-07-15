class Pawn < Piece

  def legal_moves(board)
    moves_vector = []
    if @has_moved.nil?
      moves_vector += upward_moves(board).first(2)
    else
      moves_vector += [upward_moves(board).first]
    end
    @has_moved = true
    moves_vector
     
  end

  def unicode
    @color == "white" ? "♙ ".cyan : "♟︎ ".yellow 
  end
  
end