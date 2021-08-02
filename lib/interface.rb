# frozen_string_literal: true

class Interface
  def welcome
    puts "Welcome to Chess!\nGet ready to play, enjoy."
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