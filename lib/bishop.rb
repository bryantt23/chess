require_relative './piece'

class Bishop < Piece
  def initialize(color)
    super(color)
    @display_name = 'B'
  end
end
