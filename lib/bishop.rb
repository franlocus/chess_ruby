class Bishop < Piece

  def legal_moves(board)
   upright_moves(board) + downright_moves(board) + downleft_moves(board) + upleft_moves(board)
  end

  def unicode
    @color == "white" ? "♗ ".magenta : "♝ ".yellow 
  end
  
end