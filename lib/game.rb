# frozen_string_literal: true

require_relative 'piece'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'pawn'
require_relative 'king'
require_relative 'board'
require_relative 'player'
require_relative 'colorize'

class ChessGame
  def initialize
    @board = Board.new
    @player_white = Player.new('white', @board.white_king)
    @player_black = Player.new('black', @board.black_king)
  end

  def play_game
    loop do
      display_score_board
      play_turn(@player_white)
      display_score_board
      play_turn(@player_black)
    end
  end

  private

  def play_turn(player, color = player.color)
    if @board.under_check?(color)
      unless can_move?(player)
        abort "#{color == 'white' ? 'BLACK' : 'WHITE'} WINS by CHECK MATE\nGame over\n".reverse_color
      end
      checker = @board.fetch_checker(player.king, @board)
      forced_turn(player, checker)
    else
      abort "DRAW by STALE MATE\nGame over\n".reverse_color unless can_move?(player)
      normal_turn(player)
    end
  end

  def forced_turn(player, checker)
    puts "\nCHECK!\nPlayer #{player.color.underline} please enter the forced piece you would like to move:".cyan
    forced_pieces = @board.forced_pieces(player.king, checker)
    selected_piece = player.select_piece(@board, forced_pieces.keys)
    piece_legal_moves = forced_pieces[selected_piece]
    selected_move = player.select_move(piece_legal_moves)
    make_move(selected_piece, selected_move, player)
  end

  def can_move?(player)
    total_moves = 0
    @board.squares.each do |row|
      row.each do |square|
        next if square.nil? || square.color != player.color

        total_moves += 1 unless @board.legal_moves(square.square, player).empty?
      end
    end
    !total_moves.zero?
  end

  def normal_turn(player)
    puts "\nPlayer #{player.color.underline} please enter the piece you would like to move:"
    while (selected_piece = player.select_piece(@board))
      piece_legal_moves = @board.legal_moves(selected_piece, player)
      break unless piece_legal_moves.empty?

      puts 'Sorry, no moves available for that piece, choose another one.'.red
    end
    selected_move = player.select_move(piece_legal_moves)
    make_move(selected_piece, selected_move, player)
  end

  def make_move(from_square, to_square, player)
    piece = @board.fetch_piece(from_square)
    piece.square = to_square
    player.score << @board.fetch_piece(to_square).unicode if @board.piece?(to_square)
    if piece.is_a?(Pawn) && [0, 7].include?(to_square.first)
      promote_pawn(from_square, to_square, player)
    else
      @board.move_piece!(from_square, to_square, piece)
    end
  end

  def promote_pawn(from_square, to_square, player, color = player.color)
    @board.squares[from_square.first][from_square.last] = nil
    @board.squares[to_square.first][to_square.last] = case player.promote_piece
                                                      when '1' then Queen.new(to_square, color)
                                                      when '2' then Rook.new(to_square, color)
                                                      when '3' then Bishop.new(to_square, color)
                                                      else Knight.new(to_square, color)
                                                      end
  end

  def castle
    
  end

  def display_score_board
    puts "  #{@player_black.score.join(' ')}"
    display_board
    puts "  #{@player_white.score.join(' ')}"
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

chess = ChessGame.new

chess.play_game
