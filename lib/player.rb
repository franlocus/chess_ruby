# frozen_string_literal: true

class Player
  attr_accessor :score
  attr_reader :is_white

  def initialize(is_white)
    @is_white = is_white
    @score = []
  end
end
