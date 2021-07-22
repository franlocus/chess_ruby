# frozen_string_literal: true

class Player
  attr_accessor :score, :king
  attr_reader :color

  def initialize(color, king)
    @color = color
    @king = king
    @score = []
  end

  def input_piece
    loop do
      input = gets.chomp
      return to_coordinates(input) if input.match?(/[a-h][1-8]$/)

      puts "Input error, please introduce a valid algebraic notation, eg. 'a1' or 'b5'".red
    end
  end

  def select_piece(board, forced_pieces = nil)
    unless forced_pieces.nil?
      while (selected_piece = input_piece)
        return selected_piece if forced_pieces.include?(selected_piece)

        puts "Input error: #{''.underline}.\nDon't worry, try again!".red
      end
    end
    while (selected_piece = input_piece)
      return selected_piece unless board.enemy_piece?(selected_piece, @color) || !board.piece?(selected_piece)

      puts "Input error, that's unavailable because is: #{'blank or enemy piece'.underline}.\nDon't worry, try again!".red
    end
  end

  def select_move(legal_moves)
    while (selected_move = input_piece)
      return selected_move if legal_moves.include?(selected_move) || [legal_moves].include?(selected_move)

      puts "Input error: #{'invalid legal move'.underline}.\nDon't worry, try again!".red
    end
  end

  def promote_piece
    puts "Pawn promotion! Please choose the new piece:\n1 - Queen\n2 - Rook\n3 - Bishop\n4 - Knight".cyan
    loop do
      input = gets.chomp
      return input if input.match?(/[1-4]$/)

      puts 'Input error, please introduce a valid option: 1, 2, 3, 4'.red
    end
  end

  def to_coordinates(algebraic)
    algebraic = algebraic.chars
    [(algebraic.last.to_i - 8).abs, algebraic.first.ord - 97]
  end
end
