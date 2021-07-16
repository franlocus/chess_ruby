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
      return upward unless current_position.all? { |n| n.between?(0, 7) }

      return upward << current_position if board.enemy_piece?(current_position, color)
      return upward if board.piece?(current_position)

      upward << current_position
    end
  end

  def rightward_moves(board, rightward = [], current_position = @square)
    loop do
      current_position = [current_position.first, current_position.last + 1]
      return rightward unless current_position.all? { |n| n.between?(0, 7) }

      return rightward << current_position if board.enemy_piece?(current_position, color)
      return rightward if board.piece?(current_position)

      rightward << current_position
    end
  end

  def downward_moves(board, downward = [], current_position = @square)
    loop do
      current_position = [current_position.first + 1, current_position.last]
      return downward unless current_position.all? { |n| n.between?(0, 7) }

      return downward << current_position if board.enemy_piece?(current_position, color)
      return downward if board.piece?(current_position)

      downward << current_position
    end
  end

  def leftward_moves(board, leftward = [], current_position = @square)
    loop do
      current_position = [current_position.first, current_position.last - 1]
      return leftward unless current_position.all? { |n| n.between?(0, 7) }

      return leftward << current_position if board.enemy_piece?(current_position, color)
      return leftward if board.piece?(current_position)

      leftward << current_position
    end
  end

  def upright_moves(board, upright = [], current_position = @square)
    loop do
      current_position = [current_position.first - 1, current_position.last + 1]
      return upright unless current_position.all? { |n| n.between?(0, 7) }

      return upright << current_position if board.enemy_piece?(current_position, color)
      return upright if board.piece?(current_position)

      upright << current_position
    end
  end

  def downright_moves(board, downright = [], current_position = @square)
    loop do
      current_position = [current_position.first + 1, current_position.last + 1]
      return downright unless current_position.all? { |n| n.between?(0, 7) }

      return downright << current_position if board.enemy_piece?(current_position, color)
      return downright if board.piece?(current_position)

      downright << current_position
    end
  end

  def upleft_moves(board, upleft = [], current_position = @square)
    loop do
      current_position = [current_position.first - 1, current_position.last - 1]
      return upleft unless current_position.all? { |n| n.between?(0, 7) }

      return upleft << current_position if board.enemy_piece?(current_position, color)
      return upleft if board.piece?(current_position)

      upleft << current_position
    end
  end

  def downleft_moves(board, downleft = [], current_position = @square)
    loop do
      current_position = [current_position.first + 1, current_position.last - 1]
      return downleft unless current_position.all? { |n| n.between?(0, 7) }

      return downleft << current_position if board.enemy_piece?(current_position, color)
      return downleft if board.piece?(current_position)

      downleft << current_position
    end
  end
end