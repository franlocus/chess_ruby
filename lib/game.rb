require_relative 'board'
class ChessGame

  def initialize
    @board = Board.new
  end

  def play_game
    loop do
      @board.display_board
      puts "#{'White turn'.underline}\nPlease enter the piece you would like to move:"
      puts "The piece can move to:\n#{algebraic_legal_moves(to_coordinates(algebraic_input_player)).join(' ')}".green
    end
  end

  def algebraic_legal_moves(coordinates)
    piece_moves = @board.legal_moves(coordinates)
    piece_moves.map { |move| to_algebraic(move) }
  end

  def algebraic_input_player
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
