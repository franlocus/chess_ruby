# frozen_string_literal: true

class Player
  attr_accessor :score, :played_moves
  attr_reader :is_white

  def initialize(is_white)
    @is_white = is_white
    @score = []
    @played_moves = []
  end
end