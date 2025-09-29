require_relative './piece'

class King < Piece
  def initialize(color)
    super(color)
    @display_name = 'K'
  end

  def valid_move?(from, to, grid = nil)
    return :illegal if from == to

    colFrom = from[1]
    rowFrom = from[0]
    rowTo = to[0]
    colTo = to[1]

    if rowFrom == rowTo && colFrom == colTo
      :illegal
    elsif (colFrom - colTo).abs <= 1 && (rowFrom - rowTo).abs <= 1
      destination_square = grid[rowTo][colTo]
      if destination_square.nil?
        :ok
      elsif destination_square.color == color
        :blocked
      else
        :capture
      end
    else
      :illegal
    end
  end
end
