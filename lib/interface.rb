# frozen_string_literal: true

class Interface
  attr_reader :moves_calculator, :board

  def initialize(board, moves_calculator)
    @board = board
    @moves_calculator = moves_calculator
  end

  def game_type
    puts "Welcome to Chess!\nGet ready to play, enjoy.\nSelect a game mode:\n1: New Game\n2: Load Game".cyan
    while (game_type = gets.chomp.to_i)
      return game_type if [1, 2].include?(game_type)

      puts 'Please choose 1 or 2'.red
    end
  end

  def player_select_forced_piece(is_white)
    king = board.king(is_white)
    checker = moves_calculator.checker(king)
    forced_pieces = moves_calculator.forced_pieces(king, checker)
    puts is_white ? 'White turn. YOU ARE UNDER CHECK!'.underline.cyan : 'Black turn. YOU ARE UNDER CHECK!'.underline.cyan
    verify_valid_piece(prompt_valid_input, is_white) || try_again_input_piece(is_white)
  end

  def player_select_piece(is_white)
    puts is_white ? 'White turn'.underline : 'Black turn'.underline
    verify_valid_piece(prompt_valid_input, is_white) || try_again_input_piece(is_white)
  end

  def verify_valid_piece(algebraic, is_white)
    coordinates = to_coordinates(algebraic)
    return coordinates if piece_with_player_color?(coordinates, is_white) && piece_can_move?(coordinates)
  end

  def piece_with_player_color?(coordinates, is_white)
    piece = board.piece(coordinates)
    return true unless piece.nil? || piece.is_white != is_white
  end

  def piece_can_move?(coordinates)
    !moves_calculator.legal_moves(coordinates).empty?
  end

  def try_again_input_piece(is_white)
    puts "Sorry, the piece can't move or is not available(is enemy or a blank square)".red
    player_select_piece(is_white)
  end

  def player_select_move(coordinates, is_white)
    moves = moves_calculator.legal_moves(coordinates)
    display_board_with_moves(moves)
    puts "The piece can move to:\n#{to_algebraic(moves).green}"
    verify_valid_move(to_coordinates(prompt_valid_input), moves) || try_again_input_move(coordinates, is_white)
  end

  def verify_valid_move(selected_move, moves)
    # TODO: review the use of [move]
    return selected_move if moves.include?(selected_move) || [moves].include?(selected_move)
  end

  def try_again_input_move(coordinates, is_white)
    puts 'Invalid move! Please try again'.red
    player_select_move(coordinates, is_white)
  end

  def try_again_prompt
    puts "Sorry, input error! Please introduce a valid algebraic notation, eg. 'a1' or 'b5'".red
    prompt_valid_input
  end

  def prompt_valid_input
    puts "\nPlease enter a square in algebraic notation:".cyan
    validate_algebraic(gets.chomp) || try_again_prompt
  end

  def validate_algebraic(input)
    return input if input.match?(/^[a-h][1-8]$/)
  end

  def to_coordinates(algebraic)
    algebraic = algebraic.chars
    [(algebraic.last.to_i - 8).abs, algebraic.first.ord - 97]
  end

  def to_algebraic(coordinates)
    if coordinates.any?(Array)
      coordinates.map { |move| to_algebraic(move) }.join(' ')
    else
      (coordinates.last + 97).chr + (coordinates.first - 8).abs.to_s
    end
  end

  def player_select_promotion
    puts "Pawn promotion! Please choose the new piece:\n[1] - Queen\n[2] - Rook\n[3] - Bishop\n[4] - Knight".cyan
    loop do
      input = gets.chomp
      return input.to_i if input.match?(/[1-4]$/)

      puts 'Input error, please introduce a valid option: 1, 2, 3, 4'.red
    end
  end

  def display_board
    board.squares.each_with_index do |row, idx_row|
      print  (idx_row - 8).abs, ' │' 
      row.each_with_index do |square, idx_square|
        print black_square?(idx_row, idx_square) ? square.unicode.bg_black : square.unicode.bg_gray
      end
      print "│\n"
    end
  end

  def display_board_with_moves(moves)
    # TODO: fix bg red, moves
    board.squares.each_with_index do |row, idx_row|
      print  (idx_row - 8).abs, ' │' 
      row.each_with_index do |square, idx_square|
        if moves.include?([idx_row, idx_square])
          print square.unicode(true)
        else
          print black_square?(idx_row, idx_square) ? square.unicode.bg_gray : square.unicode.bg_black
        end
      end
      print "│\n"
    end
  end

  def black_square?(idx_row, idx_square)
    idx_row.even? && idx_square.even? || idx_row.odd? && idx_square.odd?
  end
end
