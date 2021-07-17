require_relative 'board'
class ChessGame

  def initialize
    @board = Board.new
  end

  def play_game
    loop do
      play_turn('white')
      
    end
  end

  def play_turn(player_color)
    display_board
    puts "Player #{player_color.capitalize.underline} please enter the piece you would like to move:"
    selected_piece = algebraic_input_player(player_color)
    selected_piece_legal_moves = algebraic_legal_moves(to_coordinates(selected_piece))
    puts "The piece can move to:\n#{selected_piece_legal_moves.join(' ')}".green
    puts "Now type where the piece should move:"

  end

  def algebraic_legal_moves(piece_coordinates)
    piece_moves = @board.legal_moves(piece_coordinates)
    piece_moves.map { |move| to_algebraic(move) }
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

  private

  def to_algebraic(coordinates)
    (coordinates.last + 97).chr + (coordinates.first - 8).abs.to_s
  end

  def to_coordinates(algebraic)
    algebraic = algebraic.chars
    [(algebraic.last.to_i - 8).abs, algebraic.first.ord - 97]
  end

  def black_square?(idx_row, idx_square)
    idx_row.even? && idx_square.even? || idx_row.odd? && idx_square.odd?
  end
  
end

chess = ChessGame.new

chess.play_game
