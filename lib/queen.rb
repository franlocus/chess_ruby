# frozen_string_literal: true

class Queen < Piece
  def moves(board, preventive_move = false, hash_format = false)
    moves = { 'upright_moves' => upright_moves(board, preventive_move),
              'downright_moves' => downright_moves(board, preventive_move),
              'downleft_moves' => downleft_moves(board, preventive_move),
              'upleft_moves' => upleft_moves(board, preventive_move),
              'upward_moves' => upward_moves(board, preventive_move),
              'rightward_moves' => rightward_moves(board, preventive_move),
              'downward_moves' => downward_moves(board, preventive_move),
              'leftward_moves' => leftward_moves(board, preventive_move) }
              puts moves
    hash_format ? moves : moves.values.flatten(1)
  end

  def unicode
    @color == "white" ? "♕ ".magenta  : "♛ ".yellow  
  end
end