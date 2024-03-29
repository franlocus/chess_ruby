# frozen_string_literal: true

class Rook < Piece
  def moves(board, preventive_move = false, hash_format = false)
    moves = {
      'upward_moves' => upward_moves(board, preventive_move),
      'rightward_moves' => rightward_moves(board, preventive_move),
      'downward_moves' => downward_moves(board, preventive_move),
      'leftward_moves' => leftward_moves(board, preventive_move)
    }
    hash_format ? moves : moves.values.flatten(1)
  end

  def unicode(printing_moves = false)
    if printing_moves
      is_white ? '♖⌝'.magenta.bg_red : '♜⌝'.yellow.bg_red
    else
      is_white ? '♖ '.magenta : '♜ '.yellow
    end
  end
end