# frozen_string_literal: true

class Bishop < Piece
  def unicode
    @color == "white" ? "♗ ".magenta : "♝ ".yellow 
  end
end