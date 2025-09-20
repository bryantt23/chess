require_relative './piece'

class Queen < Piece
  def initialize(color)
    super(color)
    @display_name = 'Q'
  end

  def valid_move?(from, to)
    return false if from == to

    valid_diagonal?(from, to) || valid_straight?(from, to)
  end
end
