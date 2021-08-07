# frozen_string_literal: true

class MovesController
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def make_move(from_square, to_square, player)
    piece = board.piece(from_square)
    update_player_score(player, to_square)

    if castle_move?(piece, to_square)
      castle(king, from_square, to_square)
    elsif piece.is_a?(Pawn) && piece.en_passant == [to_square]
      en_passant(from_square, to_square, piece, player)
    elsif piece.is_a?(Pawn) && [0, 7].include?(to_square.first)
      promote_pawn(from_square, to_square, player)
    else
      move_piece!(from_square, to_square, piece)
    end
  end

  def move_piece!(from_square, to_square, piece)
    board.squares[from_square.first][from_square.last] = nil
    board.squares[to_square.first][to_square.last] = piece
    piece.moved = true
    piece.square = to_square
  end

  def update_player_score(player, to_square)
    player.score << board.piece(to_square).unicode if board.piece(to_square)
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

  def castle_move?(piece, to_square)
    return false if piece.moved

    piece.is_a?(King) && [[0, 2], [0, 6], [7, 2], [7, 6]].include?(to_square)
  end

  def castle(king, from_square, to_square)
    move_piece!(from_square, to_square, king)
    if to_square.last.eql?(6)
      rook = king.right_rook
      rook_new_square = king.is_white ? [7, 5] : [0, 5]
    else
      rook = king.left_rook
      rook_new_square = king.is_white ? [7, 3] : [0, 3]
    end
    move_piece!(rook.square, rook_new_square, rook)
  end

  def en_passant(from_square, to_square, piece, player)
    @board.move_piece!(from_square, to_square, piece)
    enemy_player = player.color == 'white' ? @player_black : @player_white
    eaten_pawn = @board.fetch_piece(enemy_player.last_turn_to)
    player.score << eaten_pawn.unicode
    @board.squares.map! { |row| row.map! { |square| square == eaten_pawn ? nil : square } }
  end
end
