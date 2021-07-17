class Player
  attr_accessor :score
  attr_reader :color

  def initialize(color)
    @color = color
    @score = Array.new
  end

  def input_piece
    loop do
      input = gets.chomp
      return to_coordinates(input) if input.match?(/[a-h][1-8]$/)

      puts "Input error, please introduce a valid algebraic notation, eg. 'a1' or 'b5'".red

    end
  end
  def algebraic_input_player(player_color)
    loop do
      input = gets.chomp
      return input if input.match?(/[a-h][1-8]/) && !@board.enemy_piece?(to_coordinates(input), player_color)

      puts <<~INPUT_ERROR
        Input error, please introduce:
        A piece of your color (#{player_color.capitalize.reverse_color})
        A valid algebraic notation, eg. 'a1' or 'b5'
      INPUT_ERROR

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