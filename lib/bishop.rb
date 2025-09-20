require_relative './piece'

class Bishop < Piece
  def initialize(color)
    super(color)
    @display_name = 'B'
  end

  def valid_move?(from, to)
    colFrom = from[1]
    rowFrom = from[0]
    rowTo = to[0]
    colTo = to[1]

    ((colFrom - colTo).abs == (rowFrom - rowTo).abs) && rowFrom != rowTo && colFrom != colTo
  end
end
