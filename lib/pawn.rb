# frozen_string_literal: true

class Pawn < Piece
  def unicode
    @color == 'white' ? '♙ '.magenta : '♟︎ '.yellow
  end
end