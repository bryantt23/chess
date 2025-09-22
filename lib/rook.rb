require_relative './piece'

class Rook < Piece
  def initialize(color)
    super(color)
    @display_name = 'R'
  end

  def valid_move?(from, to, grid = nil)
    return :illegal if from == to

    if valid_straight?(from, to)
      colFrom = from[1]
      rowFrom = from[0]
      rowTo = to[0]
      colTo = to[1]

      if colFrom == colTo
        min, max = [rowFrom, rowTo].minmax
        min += 1
        while min <= max
          return :blocked if grid[min][colFrom]

          min += 1
        end
      else
        min, max = [colFrom, colTo].minmax
        min += 1
        while min <= max
          return :blocked if grid[rowFrom][min]

          min += 1
        end
      end

      :ok
    else
      :illegal
    end
  end
end
