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

  def unicode
    @color == "white" ? "♗ ".magenta : "♝ ".yellow 
  end
end
