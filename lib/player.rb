class Player
  attr_accessor :score
  attr_reader :color

  def initialize(color)
    @color = color
    @score = []
  end

  def input_piece
    loop do
      input = gets.chomp
      return to_coordinates(input) if input.match?(/[a-h][1-8]$/)

      puts "Input error, please introduce a valid algebraic notation, eg. 'a1' or 'b5'".red

    end
  end
  
  def to_algebraic(coordinates)
    (coordinates.last + 97).chr + (coordinates.first - 8).abs.to_s
  end

  def to_coordinates(algebraic)
    algebraic = algebraic.chars
    [(algebraic.last.to_i - 8).abs, algebraic.first.ord - 97]
  end
  
end