class Piece

  attr_accessor :square
  attr_reader :color
  
  def initialize(square, color)
    @square = square
    @color = color
  end

  def upward_moves(board, upward = [], current_position = @square)
    loop do
      current_position = [current_position.first - 1, current_position.last]
      break unless current_position.all? { |n| n.between?(0, 7) }

      if board.piece?(current_position)
        upward << current_position unless board.color_piece(current_position) == color
        break
      end
      upward << current_position
    end
    upward
  end

  def rightward_moves(board, rightward = [], current_position = @square)
    loop do
      current_position = [current_position.first, current_position.last + 1]
      break unless current_position.all? { |n| n.between?(0, 7) }

      if board.piece?(current_position)
        rightward << current_position unless board.color_piece(current_position) == color
        break
      end
      rightward << current_position
    end
    rightward
  end

  def downward_moves(board, downward = [], current_position = @square)
    loop do
      current_position = [current_position.first + 1, current_position.last]
      break unless current_position.all? { |n| n.between?(0, 7) }

      if board.piece?(current_position)
        downward << current_position unless board.color_piece(current_position) == color
        break
      end
      downward << current_position
    end
    downward
  end

  def leftward_moves(board, leftward = [], current_position = @square)
    loop do
      current_position = [current_position.first, current_position.last - 1]
      break unless current_position.all? { |n| n.between?(0, 7) }

      if board.piece?(current_position)
        leftward << current_position unless board.color_piece(current_position) == color
        break
      end
      leftward << current_position
    end
    leftward
  end

  def upright_moves(board, upright = [], current_position = @square)
    loop do
      current_position = [current_position.first - 1, current_position.last + 1]
      break unless current_position.all? { |n| n.between?(0, 7) }

      if board.piece?(current_position)
        upright << current_position unless board.color_piece(current_position) == color
        break
      end
      upright << current_position
    end
    upright
  end

  def downright_moves(board, downright = [], current_position = @square)
    loop do
      current_position = [current_position.first + 1, current_position.last + 1]
      break unless current_position.all? { |n| n.between?(0, 7) }

      if board.piece?(current_position)
        downright << current_position unless board.color_piece(current_position) == color
        break
      end
      downright << current_position
    end
    downright
  end

  def upleft_moves(board, upleft = [], current_position = @square)
    loop do
      current_position = [current_position.first - 1, current_position.last - 1]
      break unless current_position.all? { |n| n.between?(0, 7) }

      if board.piece?(current_position)
        upleft << current_position unless board.color_piece(current_position) == color
        break
      end
      upleft << current_position
    end
    upleft
  end

  def downleft_moves(board, downleft = [], current_position = @square)
    loop do
      current_position = [current_position.first + 1, current_position.last - 1]
      break unless current_position.all? { |n| n.between?(0, 7) }

      if board.piece?(current_position)
        downleft << current_position unless board.color_piece(current_position) == color
        break
      end
      downleft << current_position
    end
    downleft
  end

  
end