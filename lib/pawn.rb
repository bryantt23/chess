require_relative './piece'

class Pawn < Piece
  def initialize(color)
    super(color)
    @display_name = 'P'
  end

  def valid_move?(from, to, grid = nil)
    return :illegal if from == to

    colFrom = from[1]
    colTo = to[1]
    rowFrom = from[0]
    rowTo = to[0]
    if @color == :white
      if rowFrom == rowTo && colFrom != colTo
        :illegal
      elsif rowTo > rowFrom
        :illegal
      elsif rowFrom == 6
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
        if (colFrom - colTo).abs == 1
          destination_square = grid[rowTo][colTo]
          if destination_square.nil?
            :ok
          elsif destination_square.color == color
            :blocked
          else
            :capture
          end
        elsif grid[rowTo][colTo].nil?
          :ok
        else
          :blocked
        end
      else
        :illegal
      end
    elsif @color == :black
      if rowFrom == rowTo && colFrom != colTo
        :illegal
      elsif rowTo < rowFrom
        :illegal
      elsif rowFrom == 1
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
        if (colFrom - colTo).abs == 1
          destination_square = grid[rowTo][colTo]
          if destination_square.nil?
            :ok
          elsif destination_square.color == color
            :blocked
          else
            :capture
          end
        elsif grid[rowTo][colTo].nil?
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
