# frozen_string_literal: true

class MovesController
  attr_reader :board, :interface

  def initialize(board, interface)
    @board = board
    @interface = interface
  end

  def make_move(from_square, to_square, player)
    piece = board.piece(from_square)
    update_player_score(player, to_square) if board.piece(to_square)
    determine_move_to_execute(from_square, to_square, player, piece)
  end

  def determine_move_to_execute(from_square, to_square, player, piece)
    if castle_move?(piece, to_square)
      castle(piece, from_square, to_square)
    elsif en_passan_move?(piece, to_square)
      en_passant(from_square, to_square, piece, player)
    elsif pawn_promotion?(piece, to_square)
      promote_pawn(from_square, to_square, player)
    else
      move_piece!(from_square, to_square, piece)
    end
  end

  def move_piece!(from_square, to_square, piece)
    update_board(from_square, to_square, piece)
    update_piece(piece, to_square)
  end

  def update_board(from_square, to_square, piece)
    board.squares[from_square.first][from_square.last] = nil
    board.squares[to_square.first][to_square.last] = piece
    board.history_moves << [from_square, to_square]
  end

  def update_piece(piece, to_square)
    piece.moved = true
    piece.square = to_square
  end

  def update_player_score(player, to_square)
    player.score << board.piece(to_square).unicode
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

  def en_passan_move?(piece, to_square)
    piece.is_a?(Pawn) && piece.en_passant == to_square
  end

  def en_passant(from_square, to_square, piece, player)
    square_pawn_to_be_eaten = board.history_moves[-1].last
    move_piece!(from_square, to_square, piece)
    update_player_score(player, square_pawn_to_be_eaten)
    update_board(from_square, square_pawn_to_be_eaten, nil) # delete pawn eaten
  end

  def pawn_promotion?(piece, to_square)
    piece.is_a?(Pawn) && [0, 7].include?(to_square.first)
  end

  def promote_pawn(from_square, to_square, player)
    piece = piece_to_promote(to_square, player.is_white)
    update_board(from_square, to_square, piece)
  end

  def piece_to_promote(to_square, is_white)
    case interface.player_select_promotion
    when 1 then Queen.new(is_white, to_square)
    when 2 then Rook.new(is_white, to_square)
    when 3 then Bishop.new(is_white, to_square)
    when 4 then Knight.new(is_white, to_square)
    end
  end
end
