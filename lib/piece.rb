class Piece

  attr_accessor :square
  attr_reader :color
  
  def initialize(square, color)
    @square = square
    @color = color
  end
  
end