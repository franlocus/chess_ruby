# frozen_string_literal: true


class Square
  attr_reader :bg_color

  def initialize(y_axis, x_axis)
    @y = y_axis
    @x = x_axis
    @bg_color = black_square?(y_axis, x_axis) ? 'white' : 'black' 
  end

  def black_square?(y, x)
    y.even? && x.even? || y.odd? && x.odd?
  end
end