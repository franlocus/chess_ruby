# frozen_string_literal: true

class King < Piece
  def legal_moves(board, defence_move = false, checker = false)
    if checker
      xrayed = xrayed(board, checker)
      normal_legal_moves(board, defence_move).reject { |move| xrayed.include?(move) }
    else
      normal_legal_moves(board, defence_move)
    end
  end

  def normal_legal_moves(board, defence_move)
    moves_vector = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
    moves_vector.map { |y, x| [square[0] + y, square[1] + x] }.select { |move| valid_move?(move, board, defence_move) }
    # add castle moves
  end

  def valid_move?(move, board, defence_move)
    within_board?(move) &&
      !board.defended_squares_by(@color == 'white' ? 'black' : 'white').include?(move) &&
      ((!board.piece?(move) || board.enemy_piece?(move,  @color)) || (defence_move && board.piece?(move)))
  end

  def xrayed(board, checker)
    return [] if %w[Pawn Knight].include?(checker.class.to_s)

    board = board.clone
    board.squares = board.squares.map { |row| row.map { |square| square == self ? nil : square } }
    checker.legal_moves(board, false, 'Hash').each_value { |value| return value if value.include?(self.square) }
  end

  def bordering_squares
    moves_vector = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
    moves_vector.map { |y, x| [square[0] + y, square[1] + x] }.select { |move| within_board?(move) }
  end

  def short_castle?
    #no se ha movido ni rey ni rook
    #no under check, ni attacked squares al pasar o terminar
    #que no haya pieza en el medio
    !@has_moved && !@right_rook.has_moved? &&

  end

  def long_castle?
    
  end

  def unicode
    @color == "white" ? "♔ ".magenta : "♚ ".yellow 
  end
end