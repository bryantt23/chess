require_relative './piece'

class Pawn < Piece
  def initialize(color)
    super(color)
    @display_name = 'P'
  end

  def is_illegal_move?(rowFrom, colFrom, rowTo, colTo, direction)
    if rowFrom == rowTo || (colFrom - colTo).abs > 1 || (rowFrom - rowTo).abs > 2 || ((colFrom - colTo).abs == 1 && (rowFrom - rowTo).abs != 1)
      true
    else
      direction == :up ? (rowTo > rowFrom) : (rowTo < rowFrom)
    end
  end

  def capture_result(rowTo, colTo, grid)
    destination_square = grid[rowTo][colTo]
    if destination_square.nil?
      :illegal
    elsif destination_square.color == color
      :blocked
    else
      :capture
    end
  end

  def valid_move?(from, to, grid = nil)
    return :illegal if from == to

    colFrom = from[1]
    colTo = to[1]
    rowFrom = from[0]
    rowTo = to[0]
    if @color == :white
      return :illegal if is_illegal_move?(rowFrom, colFrom, rowTo, colTo, :up)

      return capture_result(rowTo, colTo, grid) if (colFrom - colTo).abs == 1 && (rowFrom - rowTo).abs == 1

      if rowFrom == 6
        if rowTo >= 4
          rowFrom -= 1
          while rowFrom >= rowTo
            return :blocked unless grid[rowFrom][colFrom].nil?

            rowFrom -= 1
          end
          :ok
        else
          :illegal
        end
      elsif (rowTo - rowFrom).abs == 1
        if grid[rowTo][colTo].nil?
          :ok
        else
          :blocked
        end
      else
        :illegal
      end
    elsif @color == :black
      return :illegal if is_illegal_move?(rowFrom, colFrom, rowTo, colTo, :down)

      return capture_result(rowTo, colTo, grid) if (colFrom - colTo).abs == 1 && (rowFrom - rowTo).abs == 1

      if rowFrom == 1
        if rowTo <= 3

          rowFrom += 1
          while rowFrom <= rowTo
            return :blocked unless grid[rowFrom][colFrom].nil?

            rowFrom += 1
          end

          :ok
        else
          :illegal
        end
      elsif rowTo - rowFrom == 1
        if grid[rowTo][colTo].nil?
          :ok
        else
          :blocked
        end
      else
        :illegal
      end
    end
  end
end
