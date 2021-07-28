# frozen_string_literal: true

require 'json'
require_relative 'chess_game'
require_relative 'piece'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'pawn'
require_relative 'king'
require_relative 'board'
require_relative 'player'
require_relative 'colorize'

module BasicSerializable

  @@serializer = JSON

  def serialize
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    @@serializer.dump obj
  end

  def unserialize(string)
    obj = @@serializer.parse(string)
    obj.keys.each do |key|
      instance_variable_set(key, obj[key])
    end
  end
end
def save_game
  File.open("last_game.json", "w"){ |file| file.puts self.serialize }
end

def load_game
  self.unserialize(File.open("last_game.json", "r"){ |file| file.read})
end

chess = ChessGame.new

chess.play_game
