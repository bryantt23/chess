require_relative './piece'

class Pawn < Piece
  def initialize(color)
    super(color)
    @display_name = 'P'
  end
end
