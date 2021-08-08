
require 'yaml'

class Board
  attr_accessor :squares
 def initialize
   @squares = [Rook.new(true, [7, 2])]
 end
end

class Rook
  attr_accessor :square
 def initialize(is_white, square)
  @is_white = is_white
   @square = square
 end
end

board = Board.new

serialized = board.to_yaml
board = YAML.load("--- !ruby/object:Board\nsquares:\n- !ruby/object:Rook\n  is_white: true\n  square:\n  - 7\n  - 2\n"
)



"--- !ruby/object:Board\nsquares:\n- !ruby/object:Rook\n  is_white: true\n  square:\n  - 7\n  - 2\n"
