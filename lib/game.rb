# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

class ChessGame
  def initialize
    @board = Board.new
    @player_white = Player.new('white')
    @player_black = Player.new('black')
  end

  def play_game
    loop do
      puts "\nPlayer #{'White'.underline} please enter the piece you would like to move:"
      display_gui
      play_turn(@player_white)
    end
  end

  private

  def play_turn(player)
    selected_piece = select_piece(player)
    piece_legal_moves = legal_moves(selected_piece)
    puts "The piece can move to:\n#{to_algebraic(piece_legal_moves).green}\nNow type where the piece should move:"
    selected_move = select_move(player, piece_legal_moves)
    player_turn(selected_piece, selected_move, player)
  end

  def select_piece(player)
    while (selected_piece = player.input_piece)
      return selected_piece unless @board.enemy_piece?(selected_piece, player.color) || !@board.piece?(selected_piece)

      puts "Input error, that's unavailable because is: #{'blank or enemy piece'.underline}.\nDon't worry, try again!".red
    end
  end

  def select_move(player, legal_moves)
    while (selected_move = player.input_piece)
      return selected_move if legal_moves.include?(selected_move)

      puts "Input error: #{'invalid legal move'.underline}.\nDon't worry, try again!".red
    end
  end

  def player_turn(from_square, to_square, player)
    piece = @board.squares[from_square.first][from_square.last]
    piece.square = to_square
    if @board.piece?(to_square)
      @board.capture_piece!(from_square, to_square, piece, player)
    else
      @board.move_piece!(from_square, to_square, piece)
    end
  end

  def legal_moves(piece_coordinates)
    @board.legal_moves(piece_coordinates)
  end

  def display_gui
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
