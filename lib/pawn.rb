# frozen_string_literal: true

class Pawn < Piece
  attr_reader :en_passant
  
  def moves(board, preventive_move = false, _ = false)
    if is_white
      up_moves(board) + up_diagonals_attack(board, preventive_move) + en_passant_move(board, 1, 3, 2)
    else
      down_moves(board) + down_diagonals_attack(board, preventive_move) + en_passant_move(board, 6, 4, 5)
    end
  end

  def en_passant_move(board, from_row, to_row, capture_row)
    return [] if board.history_moves.empty?

    last_turn_from = board.history_moves[-1].first
    last_turn_to = board.history_moves[-1].last
    last_piece = board.piece(last_turn_to)
    return [] unless en_passant?(last_piece, from_row, to_row, last_turn_from[0], last_turn_to)

    @en_passant = [[capture_row, last_turn_to[1]]]
  end

  def en_passant?(last_piece, from_row, to_row, last_turn_from, last_turn_to)
    return false unless square.first == to_row

    last_piece.is_a?(Pawn) &&
      ((last_turn_from == from_row) && (last_turn_to[0] == to_row)) &&
      last_turn_to[1].between?(square[1] - 1, square[1] + 1)
  end

  def generate_two_moves(is_white)
    vectors = is_white ? [[-1, 0], [-2, 0]] : [[1, 0], [2, 0]]
    vectors.map { |y, x| [square[0] + y, square[1] + x] }
  end

  def up_moves(board)
    two_moves_up = generate_two_moves(is_white)
    return [] if board.piece(two_moves_up.first)

    if moved || board.piece(two_moves_up.last)
      two_moves_up.tap(&:pop)
    else
      two_moves_up
    end
  end

  def down_moves(board)
    two_moves_down = generate_two_moves(is_white)
    return [] if board.piece(two_moves_down.first)

    if moved || board.piece(two_moves_down.last)
      two_moves_down.tap(&:pop)
    else
      two_moves_down
    end
  end

  def up_diagonals_attack(board, preventive_move)
    up_diagonals = [[square[0] - 1, square[1] - 1], [square[0] - 1, square[1] + 1]]
    up_diagonals.keep_if do |diagonal|
      within_board?(diagonal) &&
      if encounter_piece?(board, diagonal)
        preventive_move || can_capture?(board, diagonal)
      end
    end
  end

  def down_diagonals_attack(board, preventive_move)
    down_diagonals = [[square[0] + 1, square[1] - 1], [square[0] + 1, square[1] + 1]]
    down_diagonals.keep_if do |diagonal|
      within_board?(diagonal) &&
      if encounter_piece?(board, diagonal)
        preventive_move || can_capture?(board, diagonal)
      end
    end
  end
  
  def unicode(printing_moves = false)
    if printing_moves
      is_white ? '♙⌝'.magenta.bg_red : '♟︎⌝'.yellow.bg_red
    else
      is_white ? '♙ '.magenta : '♟︎ '.yellow
    end
  end
end