require_relative './piece'

class King < Piece
  def initialize(color)
    super(color)
    @display_name = 'K'
  end

  def valid_move?(from, to)
        return false if from==to

    colFrom = from[1]
    rowFrom = from[0]
    rowTo = to[0]
    colTo = to[1]

    if rowFrom == rowTo && colFrom == colTo
      false
    else
      (colFrom - colTo).abs <= 1 && (rowFrom - rowTo).abs <= 1
    end
  end
end
