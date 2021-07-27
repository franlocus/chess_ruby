# frozen_string_literal: true

class Pawn < Piece
  attr_reader :en_passant

  def legal_moves(board, defence_move = false, _ = false)
    if @color == 'white'
      up_moves(board) + up_diagonals_attack(board, defence_move) + en_passant_move(board, board.player_black, 1, 3, 2)
    else
      down_moves(board) + down_diagonals_attack(board, defence_move) + en_passant_move(board, board.player_white, 6, 4, 5)
    end
  end
  # peon si es blanco en row 3 [3, n], si es negro [4, n]
  # el ultimo movimiento del enemigo es un peon a la misma fila [3, n+1 || n-1]

  def en_passant_move(board, player, from_row, to_row, capture_row)
    return [] unless en_passant?(board, player, from_row, to_row)

    @en_passant = [[capture_row, player.last_turn_to[1]]]
  end

  def en_passant?(board, player, from_row, to_row)
    return false unless @square.first.eql?(to_row)

    last_turn_from = player.last_turn_from
    last_turn_to = player.last_turn_to
    board.fetch_piece(player.last_turn_to).is_a?(Pawn) &&
    (last_turn_from.first.eql?(from_row) && last_turn_to.first.eql?(to_row)) &&
    last_turn_to[1].between?(square[1] - 1, square[1] + 1)
  end

  def up_moves(board)
    return [] if board.piece?([square[0] - 1, square[1]])

    @has_moved == false ? upward_moves(board).first(2) : [upward_moves(board).first]
  end

  def down_moves(board)
    return [] if board.piece?([square[0] + 1, square[1]])

    @has_moved == false ? downward_moves(board).first(2) : [downward_moves(board).first]
  end

  def up_diagonals_attack(board, defence_move)
    up_diagonals = [[square[0] - 1, square[1] - 1], [square[0] - 1, square[1] + 1]]
    up_diagonals.keep_if { |diagonal| board.enemy_piece?(diagonal, color) || (board.piece?(diagonal) && defence_move) }
  end

  def down_diagonals_attack(board, defence_move)
    down_diagonals = [[square[0] + 1, square[1] - 1], [square[0] + 1, square[1] + 1]]
    down_diagonals.keep_if { |diagonal| board.enemy_piece?(diagonal, color) || (board.piece?(diagonal) && defence_move) }
  end

  def unicode
    @color == "white" ? "♙ ".magenta : "♟︎ ".yellow
  end
end
