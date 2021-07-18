# frozen_string_literal: true

class Rook < Piece

  def legal_moves(board)
    upward_moves(board) + rightward_moves(board) + downward_moves(board) + leftward_moves(board)
  end

  

  def unicode
    @color == "white" ? "♖ ".magenta : "♜ ".yellow  
  end
  
end