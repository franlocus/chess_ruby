# frozen_string_literal: true

class MovesCalculator
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def legal_moves(coordinates) 
    piece, color = fetch_piece_and_color(coordinates)
    if piece.is_a?(King)
      piece.moves(board, enemy_defended_squares(color))
    elsif under_pin?(piece, color)
      return [] if piece.is_a?(Knight)

      king = board.king(color)
      piece.moves(board) & moves_to_pinner_and_king(piece, king)
    else
      piece.moves(board)
    end
  end

  def fetch_piece_and_color(coordinates)
    piece = board.piece(coordinates)
    [piece, piece.is_white]
  end

  def forced_pieces(king, checker)
    pieces = check_blockers(checker, king)
    pieces.reject! { |piece_square| under_pin?(board.piece(piece_square), king.is_white, checker) }
    attacked_squares = enemy_defended_squares(king.is_white)
    king_moves = king.moves(board, attacked_squares, checker)
    pieces[king.square] = king_moves unless king_moves.empty?
    pieces
  end

  def check_blockers(checker, king)
    defenders = defenders(checker, king)
    intercepters = intercepters(checker, king)
    defenders.merge(intercepters) do |_key, defender_val, intercepter_val|
      defender_val = [defender_val] unless defender_val.any?(Array)
      intercepter_val = [intercepter_val] unless intercepter_val.any?(Array)
      defender_val + intercepter_val
    end
  end

  def defenders(checker, king)
    defenders = {}
    player_pieces(king.is_white).each do |piece|
      next if piece.is_a?(King)

      defenders[piece.square] = checker.square if piece.moves(board).include?(checker.square)
    end
    defenders
  end

  def player_pieces(is_white)
    board.squares.flatten(1).map { |square| square unless square.nil? || square.is_white != is_white }.compact
  end

  def intercepters(checker, king, intercepter = {})
    fire_line = search_fireline(checker, king.square)
    player_pieces(king.is_white).each do |piece|
      next if piece.is_a?(King)

      squares_in_common = piece.moves(board) & fire_line
      next if squares_in_common.empty?

      intercepter[piece.square] = squares_in_common
    end
    intercepter
  end

  def search_fireline(checker, king_square)
    return [] if %w[Pawn Knight].include?(checker.class.to_s)

    checker.moves(board, false, 'Hash').each_value { |value| return value if value.include?(king_square) }
  end

  def moves_to_pinner_and_king(piece, king)
    toward_pinner(piece, king) + toward_king(piece, king)
  end

  def toward_pinner(piece, king)
    moves = []
    pinner = fetch_pinner(piece, king)
    pinner.moves(board, false, 'Hash').each_value { |value| moves += value if value.include?(piece.square) }
    moves << pinner.square
  end

  def fetch_pinner(piece, king)
    board_clone = simulate_a_board_without_piece(piece.square)
    checker(king, board_clone)
  end

  def toward_king(piece, king)
    moves = []
    return moves if piece.is_a?(Pawn)

    piece.moves(board, true, 'Hash').each_value { |value| moves += value if value.include?(king.square) }
    moves
  end

  def checker(king, board = self.board)
    board.squares.each do |row|
      row.each do |square|
        next if square.nil? || square.is_a?(King) || !square.moves(board).include?(king.square)

        return square
      end
    end
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

  def under_pin?(piece, is_white, already_checker = nil)
    if already_checker.nil?
      board_clone = simulate_a_board_without_piece(piece.square)
    else
      board_clone = simulate_a_board_without_piece(piece.square, already_checker.square)
    end
    under_check?(is_white, board_clone)
  end

  def simulate_a_board_without_piece(piece_square, already_checker_square = nil)
    board_clone = Marshal.load(Marshal.dump(board)) # deep copy trick
    board_clone.delete_piece(piece_square)
    board_clone.delete_piece(already_checker_square) unless already_checker_square.nil?
    board_clone
  end
end
