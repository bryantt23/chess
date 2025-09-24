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

  def valid_move?(from, to, grid = nil)
    raise NotImplementedError, "#{self.class} must implement valid_move?"
  end

  def clear_diagonal?(from, to, grid)
    colFrom = from[1]
    rowFrom = from[0]
    rowTo = to[0]
    colTo = to[1]

    if colFrom < colTo # go right
      if rowFrom < rowTo
        rowFrom += 1
        colFrom += 1
        while rowFrom <= rowTo
          return :blocked if grid[rowFrom][colFrom]

          rowFrom += 1
          colFrom += 1
        end
      else
        rowFrom -= 1
        colFrom += 1
        while rowFrom >= rowTo
          return :blocked if grid[rowFrom][colFrom]

          rowFrom -= 1
          colFrom += 1
        end
      end
    elsif rowFrom < rowTo # go left
      rowFrom += 1
      colFrom -= 1
      while rowFrom <= rowTo
        return :blocked if grid[rowFrom][colFrom]

        rowFrom += 1
        colFrom -= 1
      end
    else
      rowFrom -= 1
      colFrom -= 1
      while rowFrom >= rowTo
        return :blocked if grid[rowFrom][colFrom]

        rowFrom -= 1
        colFrom -= 1
      end
    end
    :ok
  end

  def clear_straight?(from, to, grid)
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
  end
end
