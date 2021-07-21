# frozen_string_literal: true

class Queen < Piece
  def legal_moves(board, defence_move = false, output_format = 'Array')
    moves = { 'upright_moves' => upright_moves(board, defence_move),
              'downright_moves' => downright_moves(board, defence_move),
              'downleft_moves' => downleft_moves(board, defence_move),
              'upleft_moves' => upleft_moves(board, defence_move),
              'upward_moves' => upward_moves(board, defence_move),
              'rightward_moves' => rightward_moves(board, defence_move),
              'downward_moves' => downward_moves(board, defence_move),
              'leftward_moves' => leftward_moves(board, defence_move) }
    output_format == 'Hash' ? moves : moves.values.flatten(1)
  end

  def unicode
    @color == "white" ? "♕ ".magenta  : "♛ ".yellow  
  end
end