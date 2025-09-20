require_relative './piece'

class Rook < Piece
  def initialize(color)
    super(color)
    @display_name = 'R'
  end

  def valid_move?(from, to)
    colFrom = from[1]
    rowFrom = from[0]
    rowTo = to[0]
    colTo = to[1]

    (colFrom == colTo && rowFrom != rowTo) || (colFrom != colTo && rowFrom == rowTo)
  end
end
