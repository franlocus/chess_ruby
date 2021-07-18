class Pawn < Piece
  
  def legal_moves(board)
    @color == "white" ? up_moves(board) + up_diagonals_attack(board) : down_moves(board) + down_diagonals_attack(board)
  end

  def up_moves(board)
    return [] if board.piece?([square[0] - 1, square[1]])

    @has_moved == false ? upward_moves(board).first(2) : [upward_moves(board).first]
  end

  def down_moves(board)
    return [] if board.piece?([square[0] + 1, square[1]])

    @has_moved == false ? downward_moves(board).first(2) : [downward_moves(board).first]
  end

  def up_diagonals_attack(board)
    up_diagonals = [[square[0] - 1, square[1] - 1], [square[0] - 1, square[1] + 1]]
    up_diagonals.keep_if { |diagonal| board.enemy_piece?(diagonal, color) }
  end

  def down_diagonals_attack(board)
    down_diagonals = [[square[0] + 1, square[1] - 1], [square[0] + 1, square[1] + 1]]
    down_diagonals.keep_if { |diagonal| board.enemy_piece?(diagonal, color) }
  end

  def unicode
    @color == "white" ? "♙ ".magenta : "♟︎ ".yellow
  end
end
