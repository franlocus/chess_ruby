# frozen_string_literal: true

class Interface
  def initialize(board)
    @board = board
    @moves_calculator = MovesCalculator.new
  end

  def game_type
    puts "Welcome to Chess!\nGet ready to play, enjoy.\nSelect a game mode:\n1: New Game\n2: Load Game"
    while (game_type = gets.chomp.to_i)
      return game_type if [1, 2].include?(game_type)

      puts 'Please choose 1 or 2'
    end
  end

  def player_select_piece(current_player)
    while (coordinates = to_coordinates(prompt_valid_input))
      if @board.player_piece?(coordinates, current_player.color) # && @moves_calculator
        return coordinates 
      else
        puts 'Sorry, there isn\'t available piece for you in that square'
      end
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

  def display_board
    @board.squares.each_with_index do |row, idx_row|
      print (idx_row - 8).abs, ' '
      row.each do |square|
        print square.bg_color == 'black' ? square.piece.unicode.bg_black : square.piece.unicode.bg_gray
      end
      print "\n"
    end
    print "  a b c d e f g h \n"
  end
end