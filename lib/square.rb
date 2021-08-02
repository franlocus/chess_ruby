# frozen_string_literal: true

class Square
  attr_accessor :piece
  attr_reader :bg_color

  def initialize(y_axis, x_axis)
    @y = y_axis
    @x = x_axis
    @bg_color = black_square?(y_axis, x_axis) ? 'white' : 'black'
  end

  # is a bg_black square if it's  [even, even] or [odd, odd] 
  def black_square?(y_axis, x_axis)
    (y_axis.even? && x_axis.even?) || (y_axis.odd? && x_axis.odd?)
  end
end