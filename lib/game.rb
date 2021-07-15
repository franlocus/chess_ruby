require_relative 'board'
class ChessGame

  def initialize
    @board = Board.new
  end

  def play_game
    loop do
      @board.display_board
      puts "White turn\nPlease enter the piece you would like to move:"
      print display_legal_moves(to_coordinates(input_player))
    end
      
      
    
  end

  def display_legal_moves(coordinates)
    legal_moves = @board.prepare_piece(coordinates)
    legal_moves.map { |move| to_algebraic(move) }
  end

  def input_player
    loop do
      input = gets.chomp
      return input if input.match?(/[a-h][1-8]/)

      puts "Input error, please introduce a valid algebraic notation, eg. 'a1' or 'b5'"
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

chess = ChessGame.new

chess.play_game
