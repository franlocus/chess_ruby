# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'colorize'

class ChessGame
  def initialize
    @board = Board.new
    @player_white = Player.new('white')
    @player_black = Player.new('black')
  end

  def play_game
    display_board
    #raise p @board.attacked_squares_by('white')
    loop do
      play_turn(@player_white)
      play_turn(@player_black)
    end
  end

  private

  def play_turn(player)
    puts "\nPlayer #{player.color.underline} please enter the piece you would like to move:"
    selected_piece = player.select_piece(@board)
    piece_legal_moves = @board.legal_moves(selected_piece)
    puts "The piece can move to:\n#{to_algebraic(piece_legal_moves).green}\nNow type where the piece should move:"
    selected_move = player.select_move(piece_legal_moves)
    player_turn(selected_piece, selected_move, player)
    display_score_board
  end

  def player_turn(from_square, to_square, player)
    piece = @board.fetch_piece(from_square)
    piece.square = to_square
    player.score << @board.fetch_piece(to_square).unicode if @board.piece?(to_square)
    if piece.is_a?(Pawn) && [0, 7].include?(to_square.first)
      @board.promote_pawn(from_square, to_square, player.color, player.promote_piece)
    else
      @board.move_piece!(from_square, to_square, piece)
    end
  end

  def display_score_board
    puts "  #{@player_black.score.join(' ')}".yellow
    display_board
    puts "  #{@player_white.score.join(' ')}".yellow
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

  def to_algebraic(coordinates)
    if coordinates.any?(Array)
      coordinates.map { |move| to_algebraic(move) }.join(' ')
    else
      (coordinates.last + 97).chr + (coordinates.first - 8).abs.to_s
    end
  end

  def black_square?(idx_row, idx_square)
    idx_row.even? && idx_square.even? || idx_row.odd? && idx_square.odd?
  end
end

chess = ChessGame.new

chess.play_game
