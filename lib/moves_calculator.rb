# frozen_string_literal: true

class MovesCalculator
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def legal_moves(coordinates, is_white) # checker = false
    piece = board.piece(coordinates)
    if piece.is_a?(King)
      piece.moves(board, enemy_defended_squares(is_white))
      # need to cover the case when is check and need to check under_pin? double check situation 
      # require to determine first the real checker so not collide with simulated checker 
    elsif under_pin?(piece, is_white)
      return [] if piece.is_a?(Knight)

      king = board.king(is_white)
      # checker = false at the moment, complete when checking state for force move
      piece.moves(board) & moves_to_pinner_and_king(piece, king, false)
    else
      piece.moves(board)
    end
  end

  def moves_to_pinner_and_king(piece, king, checker)
    toward_pinner(piece, king, checker) + toward_king(piece, king)
  end

  def toward_pinner(piece, king, checker)
    moves = []
    pinner = fetch_pinner(piece, king, checker)
    pinner.moves(board, false, 'Hash').each_value { |value| moves += value if value.include?(piece.square) }
    moves << pinner.square
  end

  def toward_king(piece, king)
    moves = []
    return moves if piece.is_a?(Pawn)

    piece.moves(board, true, 'Hash').each_value { |value| moves += value if value.include?(king.square) }
    moves
  end

  def fetch_pinner(piece, king, checker)
    board_clone = simulate_a_board_without_piece(piece.square)
    checker(king, board_clone, checker)
  end

  def checker(king, board = self.board, checker = false)
    board.squares.each do |row|
      row.each do |square|
        next if square.nil? || square.is_a?(King) || !square.moves(board).include?(king.square)

        return square unless square == checker
      end
    end
    # returns nil in case square == checker, situation when there is double check
    nil
  end

  def under_check?(is_white, normal_or_simulated_board = board)
    attacked_squares = enemy_defended_squares(is_white, normal_or_simulated_board)
    king = normal_or_simulated_board.king(is_white)
    attacked_squares.include?(king.square)
  end

  def enemy_defended_squares(is_white, normal_simulated_board = self.board)
    attacked = []
    normal_simulated_board.squares.each do |row|
      row.each do |square|
        next if square.nil? || (square.is_white == is_white)

        attacked += square.is_a?(King) ? square.around_squares : square.moves(normal_simulated_board, true)
      end
    end
    attacked
  end

  def under_pin?(piece, is_white)
    board_clone = simulate_a_board_without_piece(piece.square)
    under_check?(is_white, board_clone)
  end

  def simulate_a_board_without_piece(piece_square)
    board_clone = Marshal.load(Marshal.dump(board)) # deep copy trick
    board_clone.delete_piece(piece_square)
    board_clone
  end
end
