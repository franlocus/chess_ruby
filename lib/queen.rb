# frozen_string_literal: true

class Queen < Piece
  def unicode
    @color == "white" ? "♕ ".magenta  : "♛ ".yellow  
  end
end