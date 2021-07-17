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
      return input if input.match?(/[a-h][1-8]/)

      puts <<~INPUT_ERROR
        Input error, please introduce:
        A piece of your color (#{player_color.capitalize.reverse_color})
        A valid algebraic notation, eg. 'a1' or 'b5'
      INPUT_ERROR

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
  
end