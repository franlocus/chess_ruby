# frozen_string_literal: true

class Interface
  def initialize(board)
    @board = board
    @moves_calculator = MovesCalculator.new(@board)
  end

  def game_type
    puts "Welcome to Chess!\nGet ready to play, enjoy.\nSelect a game mode:\n1: New Game\n2: Load Game".cyan
    while (game_type = gets.chomp.to_i)
      return game_type if [1, 2].include?(game_type)

      puts 'Please choose 1 or 2'.red
    end
  end

  def player_input_piece
    to_coordinates(prompt_valid_input)
  end

  def prompt_valid_input
    puts "\nPlayer #color please enter the piece you would like to move:".cyan
    validate_algebraic(gets.chomp) || try_again
  end

  def validate_algebraic(input)
    return input if input.match?(/^[a-h][1-8]$/)
  end

  def try_again
    puts "Sorry, input error! Please introduce a valid algebraic notation, eg. 'a1' or 'b5'".red
    prompt_valid_input
  end

  def to_coordinates(algebraic)
    algebraic = algebraic.chars
    [(algebraic.last.to_i - 8).abs, algebraic.first.ord - 97]
  end

  def display_board
    @board.squares.each_with_index do |row, idx_row|
      print (idx_row - 8).abs, ' '
      row.each_with_index do |square, idx_square|
        print black_square?(idx_row, idx_square) ? square.unicode.bg_black : square.unicode.bg_gray
      end
      print "\n"
    end
    print "  a b c d e f g h \n"
  end

  def black_square?(idx_row, idx_square)
    idx_row.even? && idx_square.even? || idx_row.odd? && idx_square.odd?
  end
end