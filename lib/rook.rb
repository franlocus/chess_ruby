# frozen_string_literal: true

class Rook < Piece
  def legal_moves(board, defence_move = false, output_format = 'Array')
    moves = {
      'upward_moves' => upward_moves(board, defence_move),
      'rightward_moves' => rightward_moves(board, defence_move),
      'downward_moves' => downward_moves(board, defence_move),
      'leftward_moves' => leftward_moves(board, defence_move)
    }
    output_format == 'Hash' ? moves : moves.values.flatten(1)
  end

  def unicode
    @color == "white" ? "♖ ".magenta : "♜ ".yellow  
  end
end