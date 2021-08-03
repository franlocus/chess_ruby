# frozen_string_literal: true

class Interface
  def game_type
    puts "Welcome to Chess!\nGet ready to play, enjoy.\nSelect a game mode:\n1: New Game or 2: Load Game"
    while (game_type = gets.chomp.to_i)
      return game_type if [1, 2].include?(game_type)

      puts 'Please choose 1: New Game or 2: Load Game'
    end
  end

  def prompt_valid_input
    puts "\nPlayer #color please enter the piece you would like to move:"
    validate(gets.chomp) || try_again
  end

  def validate(input)
    return input if input.match?(/^[a-h][1-8]$/)
  end

  def try_again
    puts "Sorry, input error! Please introduce a valid algebraic notation, eg. 'a1' or 'b5'".red
    prompt_valid_input
  end
  # TODO Complete who will receive the output from prompt to coordinates
  def to_coordinates(algebraic)
    algebraic = algebraic.chars
    [(algebraic.last.to_i - 8).abs, algebraic.first.ord - 97]
  end
end