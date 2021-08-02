# frozen_string_literal: true

class Rook < Piece
  def unicode
    @color == "white" ? "♖ ".magenta : "♜ ".yellow  
  end
end