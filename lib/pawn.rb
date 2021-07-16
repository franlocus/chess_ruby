class Pawn < Piece

  def legal_moves(board)
    @color == "white" ? white_pawn(board) + up_diagonals_attack(board) : black_pawn(board) + down_diagonals_attack(board)
  end

  def white_pawn(board, moves_vector = [])
    if board.piece?([square[0] - 1, square[1]])
      nil
    elsif @has_moved.nil?
      moves_vector += upward_moves(board).first(2)
    else
      moves_vector << upward_moves(board).first
    end
    @has_moved = true
    moves_vector
  end

  def black_pawn(board, moves_vector = [])
    if board.piece?([square[0] + 1, square[1]])
      nil
    elsif @has_moved.nil?
      moves_vector += downward_moves(board).first(2)
    else
      moves_vector << downward_moves(board).first
    end
    @has_moved = true
    moves_vector
  end

  def up_diagonals_attack(board)
      upright_attack(board) + upleft_attack(board)
  end

  def upright_attack(board, moves_vector = [])
    return moves_vector if square.last == 7
    
    if !board.color_piece(upright_moves(board).first).nil? && board.color_piece(upright_moves(board).first) != color
      moves_vector << upright_moves(board).first
    else
      moves_vector
    end
  end

  def upleft_attack(board, moves_vector = [])
    return moves_vector if square.last.zero?

    if !board.color_piece(upleft_moves(board).first).nil? && board.color_piece(upleft_moves(board).first) != color
      moves_vector << upleft_moves(board).first
    else
      moves_vector
    end
  end

  def down_diagonals_attack(board)
    downright_attack(board) + downleft_attack(board)
  end

  def downright_attack(board, moves_vector = [])
    return moves_vector if square.last == 7

    if !board.color_piece(downright_moves(board).first).nil? && board.color_piece(downright_moves(board).first) != color
      moves_vector << downright_moves(board).first
    else
      moves_vector
    end
  end

  def downleft_attack(board, moves_vector = [])
    return moves_vector if square.last.zero?

    if !board.color_piece(downleft_moves(board).first).nil? && board.color_piece(downleft_moves(board).first) != color
      moves_vector << downleft_moves(board).first
    else
      moves_vector
    end
  end

  def unicode
    @color == "white" ? "♙ ".cyan : "♟︎ ".yellow 
  end
  
end