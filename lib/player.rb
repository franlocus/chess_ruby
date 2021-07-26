# frozen_string_literal: true

class Player
  attr_accessor :score, :king, :last_movement, :last_piece
  attr_reader :color

  def initialize(color, king)
    @color = color
    @king = king
    @score = []
    @last_piece = nil
    @last_movement = nil
  end

  def input_piece
    loop do
      input = gets.chomp
      return to_coordinates(input) if input.match?(/^[a-h][1-8]$/)

      puts "Input error, please introduce a valid algebraic notation, eg. 'a1' or 'b5'".red
    end
  end

  def select_piece(board, forced_pieces = nil)
    unless forced_pieces.nil?
      puts "You can only move: #{to_algebraic(forced_pieces)}"
      while (selected_piece = input_piece)
        return @last_piece = selected_piece if forced_pieces.include?(selected_piece)

        puts "Input error: #{''.underline}.\nDon't worry, try again!".red
      end
    end
    while (selected_piece = input_piece)
      return @last_piece = selected_piece unless board.enemy_piece?(selected_piece, @color) || !board.piece?(selected_piece)

      puts "Input error, that's unavailable because is: #{'blank or enemy piece'.underline}.\nDon't worry, try again!".red
    end
  end

  def select_move(legal_moves)
    puts "The piece can move to:\n#{to_algebraic(legal_moves).green}\nNow type where the piece should move:"
    while (selected_move = input_piece)
      return @last_movement = selected_move if legal_moves.include?(selected_move) || [legal_moves].include?(selected_move)

      puts "Input error: #{'invalid legal move'.underline}.\nDon't worry, try again!".red
    end
  end

  def promote_piece
    puts "Pawn promotion! Please choose the new piece:\n[1] - Queen\n[2] - Rook\n[3] - Bishop\n[4] - Knight".cyan
    loop do
      input = gets.chomp
      return input if input.match?(/[1-4]$/)

      puts 'Input error, please introduce a valid option: 1, 2, 3, 4'.red
    end
  end

  def to_algebraic(coordinates)
    if coordinates.any?(Array)
      coordinates.map { |move| to_algebraic(move) }.join(' ')
    else
      (coordinates.last + 97).chr + (coordinates.first - 8).abs.to_s
    end
  end

  def to_coordinates(algebraic)
    algebraic = algebraic.chars
    [(algebraic.last.to_i - 8).abs, algebraic.first.ord - 97]
  end
end
