# frozen_string_literal: true

class Knight < Piece
  def unicode
    @color == "white" ? "♘ ".magenta : "♞ ".yellow 
  end
end