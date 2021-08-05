# frozen_string_literal: true

class Piece
  attr_accessor :square, :moved
  attr_reader :color

  def initialize(color, square)
    @color = color
    @square = square
    @moved = false
  end

  def moved?
    @moved
  end

  def encounter_piece?(board, position)
    board.piece(position)
  end

  def can_capture?(board, position)
    board.piece(position).color != color
  end

  def upward_moves(board, preventive_move = false,  upward = [], position = square)
    until outside_board?(position)
      position = [position.first - 1, position.last]
      if encounter_piece?(board, position)
        upward << position if preventive_move || can_capture?(board, position)

        return upward
      else
        upward << position
      end
    end
    upward
  end

  def rightward_moves(board, preventive_move = false,  rightward = [], position = square)
    until outside_board?(position)
      position = [position.first - 1, position.last]
      if encounter_piece?(board, position)
        rightward << position if preventive_move || can_capture?(board, position)

        return rightward
      else
        rightward << position
      end
    end
    rightward
  end

  def downward_moves(board, preventive_move = false,  downward = [], position = square)
    until outside_board?(position)
      position = [position.first - 1, position.last]
      if encounter_piece?(board, position)
        downward << position if preventive_move || can_capture?(board, position)

        return downward
      else
        downward << position
      end
    end
    downward
  end

  def leftward_moves(board, preventive_move = false,  leftward = [], position = square)
    until outside_board?(position)
      position = [position.first - 1, position.last]
      if encounter_piece?(board, position)
        leftward << position if preventive_move || can_capture?(board, position)

        return leftward
      else
        leftward << position
      end
    end
    leftward
  end

  def upright_moves(board, preventive_move = false,  upright = [], position = square)
    until outside_board?(position)
      position = [position.first - 1, position.last]
      if encounter_piece?(board, position)
        upright << position if preventive_move || can_capture?(board, position)

        return upright
      else
        upright << position
      end
    end
    upright
  end

  def downright_moves(board, preventive_move = false,  downright = [], position = square)
    until outside_board?(position)
      position = [position.first - 1, position.last]
      if encounter_piece?(board, position)
        downright << position if preventive_move || can_capture?(board, position)

        return downright
      else
        downright << position
      end
    end
    downright
  end

  def upleft_moves(board, preventive_move = false,  upleft = [], position = square)
    until outside_board?(position)
      position = [position.first - 1, position.last]
      if encounter_piece?(board, position)
        upleft << position if preventive_move || can_capture?(board, position)

        return upleft
      else
        upleft << position
      end
    end
    upleft
  end

  def downleft_moves(board, preventive_move = false,  downleft = [], position = square)
    until outside_board?(position)
      position = [position.first - 1, position.last]
      if encounter_piece?(board, position)
        downleft << position if preventive_move || can_capture?(board, position)

        return downleft
      else
        downleft << position
      end
    end
    downleft
  end

  def outside_board?(coordinates)
    coordinates.any? { |n| !n.between?(0, 7) }
  end
end