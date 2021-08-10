# frozen_string_literal: true

class MovesCalculator
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def legal_moves(coordinates, is_white)
    piece = board.piece(coordinates)
    if piece.is_a?(King)
      piece.moves(board, enemy_defended_squares(is_white))
    else
      under_pin?(piece, is_white)
      piece.moves(board)
    end
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

# TODO: UNDER pin? 
  def legal_moves2(coordinates, player, checker = nil)
    piece = fetch_piece(coordinates)
    if under_pin?(piece, player.king, checker)
      return [] if piece.is_a?(Knight)

      pinned_fireline(piece, player.king, checker) & piece.legal_moves(@board)
    else
      piece.legal_moves(@board)
    end
  end
end