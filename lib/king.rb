class King < Piece
  
  def legal_moves(board)
    moves_vector = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
    moves_vector
      .map { |y, x| [square[0] + y, square[1] + x] }
      .keep_if do |move|
        move[0].between?(0, 7) && move[1].between?(0, 7) &&
          (!board.piece?(move) || board.color_piece(move) != color)
      end
  end
  
  def unicode
    @color == "white" ? "♔ ".cyan : "♚ ".yellow 
  end
  
end