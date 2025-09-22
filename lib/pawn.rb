require_relative './piece'

class Pawn < Piece
  def initialize(color)
    super(color)
    @display_name = 'P'
  end

  def valid_move?(from, to, grid=nil)
    return :illegal if from == to

    colFrom = from[1]
    colTo = to[1]
    rowFrom = from[0]
    rowTo = to[0]
    if @color == 'White'
      if rowFrom == rowTo && colFrom != colTo
        :illegal
      elsif rowTo > rowFrom
        :illegal
      elsif rowFrom == 6
        if rowTo >= 4
          :ok
        else
          :illegal
        end
      elsif (rowTo - rowFrom).abs == 1
        :ok
      else
        :illegal
      end
    elsif @color == 'Black'
      if rowFrom == rowTo && colFrom != colTo
        :illegal
      elsif rowTo < rowFrom
        :illegal
      elsif rowFrom == 1
        if rowTo <= 3
          :ok
        else
          :illegal
        end
      elsif rowTo - rowFrom == 1
        :ok
      else
        :illegal
      end
    end
  end
end
