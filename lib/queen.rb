require_relative './piece'

class Queen < Piece
  def initialize(color)
    super(color)
    @display_name = 'Q'
  end
end
