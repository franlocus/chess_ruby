# frozen_string_literal: true

class Piece
  attr_accessor :square, :has_moved
  attr_reader :color

  def initialize(square, color)
    @square = square
    @color = color
    @has_moved = false
  end

  def upward_moves(board, preventive_move = false,  upward = [], cursor = @square)
    loop do
      cursor = [cursor.first - 1, cursor.last]
      return upward unless within_board?(cursor)

      return upward << cursor if board.enemy_piece?(cursor, color) || (board.piece?(cursor) && preventive_move)
      return upward if board.piece?(cursor)

      upward << cursor
    end
  end

  def rightward_moves(board, preventive_move = false,  rightward = [], cursor = @square)
    loop do
      cursor = [cursor.first, cursor.last + 1]
      return rightward unless within_board?(cursor)

      return rightward << cursor if board.enemy_piece?(cursor, color) || (board.piece?(cursor) && preventive_move)
      return rightward if board.piece?(cursor)

      rightward << cursor
    end
  end

  def downward_moves(board, preventive_move = false,  downward = [], cursor = @square)
    loop do
      cursor = [cursor.first + 1, cursor.last]
      return downward unless within_board?(cursor)

      return downward << cursor if board.enemy_piece?(cursor, color) || (board.piece?(cursor) && preventive_move)
      return downward if board.piece?(cursor)

      downward << cursor
    end
  end

  def leftward_moves(board, preventive_move = false,  leftward = [], cursor = @square)
    loop do
      cursor = [cursor.first, cursor.last - 1]
      return leftward unless within_board?(cursor)

      return leftward << cursor if board.enemy_piece?(cursor, color) || (board.piece?(cursor) && preventive_move)
      return leftward if board.piece?(cursor)

      leftward << cursor
    end
  end

  def upright_moves(board, preventive_move = false,  upright = [], cursor = @square)
    loop do
      cursor = [cursor.first - 1, cursor.last + 1]
      return upright unless within_board?(cursor)

      return upright << cursor if board.enemy_piece?(cursor, color) || (board.piece?(cursor) && preventive_move)
      return upright if board.piece?(cursor)

      upright << cursor
    end
  end

  def downright_moves(board, preventive_move = false,  downright = [], cursor = @square)
    loop do
      cursor = [cursor.first + 1, cursor.last + 1]
      return downright unless within_board?(cursor)

      return downright << cursor if board.enemy_piece?(cursor, color) || (board.piece?(cursor) && preventive_move)
      return downright if board.piece?(cursor)

      downright << cursor
    end
  end

  def upleft_moves(board, preventive_move = false,  upleft = [], cursor = @square)
    loop do
      cursor = [cursor.first - 1, cursor.last - 1]
      return upleft unless within_board?(cursor)

      return upleft << cursor if board.enemy_piece?(cursor, color) || (board.piece?(cursor) && preventive_move)
      return upleft if board.piece?(cursor)

      upleft << cursor
    end
  end

  def downleft_moves(board, preventive_move = false,  downleft = [], cursor = @square)
    loop do
      cursor = [cursor.first + 1, cursor.last - 1]
      return downleft unless within_board?(cursor)

      return downleft << cursor if board.enemy_piece?(cursor, color) || (board.piece?(cursor) && preventive_move)
      return downleft if board.piece?(cursor)

      downleft << cursor
    end
  end

  def within_board?(coordinates)
    coordinates.all? { |n| n.between?(0, 7) }
  end
end
