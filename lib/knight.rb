require_relative './piece'

class Knight < Piece
  def initialize(color)
    super(color)
    @display_name = 'N'
  end
end
