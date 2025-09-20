require_relative './piece'

class Queen < Piece
  def initialize(color)
    super(color)
    @display_name = 'Q'
  end

  def valid_move?(from, to)
    if super(from, to) == false
      false
    else
      valid_diagonal?(from, to) || valid_straight?(from, to)
    end
  end
end
