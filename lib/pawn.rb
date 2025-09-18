require_relative './piece'

class Pawn < Piece
  def initialize(color)
    @color=color
    @display_name="P"
  end
end