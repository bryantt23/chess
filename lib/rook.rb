require_relative './piece'

class Rook < Piece
  def initialize(color)
    super(color)
    @display_name = 'R'
  end

  def valid_move?(from, to)
    return false if from == to

    valid_straight?(from, to)
  end
end
