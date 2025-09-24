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
        if rowFrom < rowTo
          rowFrom += 1
          while rowFrom <= rowTo
            return :blocked if grid[rowFrom][colFrom]

            rowFrom += 1
          end
        else
          rowFrom -= 1
          while rowTo <= rowFrom
            return :blocked if grid[rowFrom][colFrom]

            rowFrom -= 1
          end
        end
      elsif colFrom < colTo
        colFrom += 1
        while colFrom <= colTo
          return :blocked if grid[rowFrom][colFrom]

          colFrom += 1
        end
      else
        colFrom -= 1
        while rowTo <= colFrom
          return :blocked if grid[rowFrom][colFrom]

          colFrom -= 1
        end
      end

      :ok
    else
      :illegal
    end
  end
end
