# frozen_string_literal: true

class Piece
  attr_accessor :moved
  attr_reader :color

  def initialize(color)
    @color = color
    @moved = false
  end

  def moved?
    @moved
  end
end