require_relative './piece'

class Bishop < Piece
  def initialize(color)
    super(color)
    @display_name = 'B'
  end

  def valid_move?(from, to)
    return false if from==to

    colFrom = from[1]
    rowFrom = from[0]
    rowTo = to[0]
    colTo = to[1]

    valid_diagonal?(from, to) && rowFrom != rowTo && colFrom != colTo
  end
end
