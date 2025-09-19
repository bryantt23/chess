require_relative './piece'

class King < Piece
  def initialize(color)
    super(color)
    @display_name = 'K'
  end
end
