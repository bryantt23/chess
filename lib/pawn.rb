require_relative './piece'

class Pawn < Piece
  def initialize(color)
    super(color)
    @display_name = 'P'
  end

  def valid_move?(from, to)
        return false if from==to

    colFrom = from[1]
    colTo = to[1]
    rowFrom = from[0]
    rowTo = to[0]
    if @color == 'White'
      if rowFrom == rowTo && colFrom != colTo
        false
      elsif rowTo > rowFrom
        false
      elsif rowFrom == 6
        rowTo >= 4
      else
        (rowTo - rowFrom).abs == 1
      end
    elsif @color == 'Black'
      if rowFrom == rowTo && colFrom != colTo
        false
      elsif rowTo < rowFrom
        false
      elsif rowFrom == 1
        rowTo <= 3
      else
        rowTo - rowFrom == 1
      end
    end
  end
end
