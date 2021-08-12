# frozen_string_literal: true

class Bishop < Piece
  def moves(board, preventive_move = false, hash_format = false)
    moves = {
      'upright_moves' => upright_moves(board, preventive_move),
      'downright_moves' => downright_moves(board, preventive_move),
      'downleft_moves' => downleft_moves(board, preventive_move),
      'upleft_moves' => upleft_moves(board, preventive_move)
    }
    hash_format ? moves : moves.values.flatten(1)
  end

  def unicode(printing_moves = false)
    if printing_moves
      is_white ? '♗⌝'.magenta.bg_red : '♝⌝'.yellow.bg_red
    else
      is_white ? '♗ '.magenta : '♝ '.yellow
    end
  end
end