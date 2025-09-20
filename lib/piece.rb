class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def display
    "#{@color[0]}#{@display_name}"
  end

  def valid_diagonal?(from, to)
    colFrom = from[1]
    rowFrom = from[0]
    rowTo = to[0]
    colTo = to[1]

    ((colFrom - colTo).abs == (rowFrom - rowTo).abs)
  end

  def valid_straight?(from, to)
    colFrom = from[1]
    rowFrom = from[0]
    rowTo = to[0]
    colTo = to[1]

    (colFrom == colTo && rowFrom != rowTo) || (colFrom != colTo && rowFrom == rowTo)
  end

end
