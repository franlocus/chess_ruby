# frozen_string_literal: true

class King < Piece
  def unicode
    @color == 'white' ? '♔ '.magenta : '♚ '.yellow
  end
end