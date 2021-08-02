# frozen_string_literal: true

class Player
  attr_accessor :score, :played_moves
  attr_reader :color

  def initialize(color)
    @color = color
    @score = []
    @played_moves = []
  end
end