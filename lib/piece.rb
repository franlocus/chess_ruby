# frozen_string_literal: true

class Piece

  attr_accessor :square
  attr_reader :color

  def initialize(square, color)
    @square = square
    @color = color
  end

  def upward_moves(board, upward = [], cursor = @square)
    loop do
      cursor = [cursor.first - 1, cursor.last]
      return upward unless within_board?(cursor)

      return upward << cursor if board.enemy_piece?(cursor, color)
      return upward if board.piece?(cursor)

      upward << cursor
    end
  end

  def rightward_moves(board, rightward = [], cursor = @square)
    loop do
      cursor = [cursor.first, cursor.last + 1]
      return rightward unless within_board?(cursor)

      return rightward << cursor if board.enemy_piece?(cursor, color)
      return rightward if board.piece?(cursor)

      rightward << cursor
    end
  end

  def downward_moves(board, downward = [], cursor = @square)
    loop do
      cursor = [cursor.first + 1, cursor.last]
      return downward unless within_board?(cursor)

      return downward << cursor if board.enemy_piece?(cursor, color)
      return downward if board.piece?(cursor)

      downward << cursor
    end
  end

  def leftward_moves(board, leftward = [], cursor = @square)
    loop do
      cursor = [cursor.first, cursor.last - 1]
      return leftward unless within_board?(cursor)

      return leftward << cursor if board.enemy_piece?(cursor, color)
      return leftward if board.piece?(cursor)

      leftward << cursor
    end
  end

  def upright_moves(board, upright = [], cursor = @square)
    loop do
      cursor = [cursor.first - 1, cursor.last + 1]
      return upright unless within_board?(cursor)

      return upright << cursor if board.enemy_piece?(cursor, color)
      return upright if board.piece?(cursor)

      upright << cursor
    end
  end

  def downright_moves(board, downright = [], cursor = @square)
    loop do
      cursor = [cursor.first + 1, cursor.last + 1]
      return downright unless within_board?(cursor)

      return downright << cursor if board.enemy_piece?(cursor, color)
      return downright if board.piece?(cursor)

      downright << cursor
    end
  end

  def upleft_moves(board, upleft = [], cursor = @square)
    loop do
      cursor = [cursor.first - 1, cursor.last - 1]
      return upleft unless within_board?(cursor)

      return upleft << cursor if board.enemy_piece?(cursor, color)
      return upleft if board.piece?(cursor)

      upleft << cursor
    end
  end

  def downleft_moves(board, downleft = [], cursor = @square)
    loop do
      cursor = [cursor.first + 1, cursor.last - 1]
      return downleft unless within_board?(cursor)

      return downleft << cursor if board.enemy_piece?(cursor, color)
      return downleft if board.piece?(cursor)

      downleft << cursor
    end
  end

  def within_board?(coordinates)
    coordinates.all? { |n| n.between?(0, 7) }
  end

end
