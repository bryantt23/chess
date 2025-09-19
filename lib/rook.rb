require_relative './piece'

class Rook < Piece
  def initialize(color)
    super(color)
    @display_name = 'R'
  end
end
