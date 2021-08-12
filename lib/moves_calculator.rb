# frozen_string_literal: true

class MovesCalculator
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def legal_moves(coordinates, is_white, checker = false) # checker = false
    # delete is_white argument, replace with piece.is_white
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

  def forced_pieces(king, checker)
    pieces = check_blockers(checker, king)
    #pieces[king.square] = king.legal_moves(self, false, checker) unless king.legal_moves(self, false, checker).empty?
    #pieces.reject { |piece_square| under_pin?(board.piece(piece_square), king.is_white, checker) }
  end
# que hacer hoy
# ayer lo ultimo fue las forced pieces
# falta agregar king si puede comerse a la piece
# testear si la pieza esta under pin no podria moverse a defender o interceptar 
# pero esta situacion es conflictiva con el metodo de chequeear si esta under pin
# analizar posibilidad de agregar argumento checker = false y pasarlo cuando haya para no dar falso positivo
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

    checker.moves(self.board, false, 'Hash').each_value { |value| return value if value.include?(king_square) }
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
    #fetch_checker(king, board_clone, checker).nil? ? false : true
  end

  def fetch_checker(king, board = self, checker = false)
    board.squares.each do |row|
      row.each do |square|
        next if square.nil? || !square.legal_moves(board).include?(king.square)

        return square unless square == checker
      end
    end
    nil
  end

  def simulate_a_board_without_piece(piece_square)
    board_clone = Marshal.load(Marshal.dump(board)) # deep copy trick
    board_clone.delete_piece(piece_square)
    board_clone
  end
end
