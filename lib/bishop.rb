# frozen_string_literal: true

class Bishop < Piece
  def legal_moves(board, defence_move = false, output_format = 'Array')
    moves = {
      'upright_moves' => upright_moves(board, defence_move),
      'downright_moves' => downright_moves(board, defence_move),
      'downleft_moves' => downleft_moves(board, defence_move),
      'upleft_moves' => upleft_moves(board, defence_move)
    }
    output_format == 'Hash' ? moves : moves.values.flatten(1)
  end

  def unicode
    @color == "white" ? "♗ ".magenta : "♝ ".yellow 
  end
end
