# frozen_string_literal: true

class ChessGame

  def initialize
    @player_white = Player.new('white')
    @player_black = Player.new('black')
    @board = Board.new(@player_white, @player_black)
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
    if @board.under_check?(player)
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
    if castle_move?(piece, from_square, to_square)
      castle(from_square, to_square, piece)
    elsif piece.is_a?(Pawn) && piece.en_passant == [to_square]
      en_passant(from_square, to_square, piece, player)
    elsif piece.is_a?(Pawn) && [0, 7].include?(to_square.first)
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

  def castle_move?(piece, from_square, to_square)
    piece.is_a?(King) &&
      [[7, 4], [0, 4]].include?(from_square) &&
      [[0, 2], [0, 6], [7, 2], [7, 6]].include?(to_square)
  end

  def castle(from_square, to_square, king)
    @board.move_piece!(from_square, to_square, king)
    if to_square.last.eql?(6)
      rook = king.right_rook
      rook_to = king.color == 'white' ? [7, 5] : [0, 5]
    else
      rook = king.left_rook
      rook_to = king.color == 'white' ? [7, 3] : [0, 3]
    end
    @board.move_piece!(rook.square, rook_to, rook)
    rook.square = rook_to
  end

  def en_passant(from_square, to_square, piece, player)
    @board.move_piece!(from_square, to_square, piece)
    enemy_player = player.color == 'white' ? @player_black : @player_white
    eaten_pawn = @board.fetch_piece(enemy_player.last_turn_to)
    player.score << eaten_pawn.unicode
    @board.squares.map! { |row| row.map! { |square| square == eaten_pawn ? nil : square } }
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