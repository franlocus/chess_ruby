class Queen < Piece

  def legal_moves(board)
      upright_moves(board) + downright_moves(board) + downleft_moves(board) + upleft_moves(board) +
      upward_moves(board) + rightward_moves(board) + downward_moves(board) + leftward_moves(board)
  end

  def unicode
    @color == "white" ? "♕ ".cyan  : "♛ ".yellow  
  end
  
end