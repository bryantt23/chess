require_relative './piece'

class Knight < Piece
  def initialize(color)
    super(color)
    @display_name = 'N'
  end

  def valid_move?(from, to, grid = nil, _en_passant_target = nil)
    return :illegal if from == to

    colFrom = from[1]
    colTo = to[1]
    rowFrom = from[0]
    rowTo = to[0]

    colDist = (colFrom - colTo).abs
    rowDist = (rowFrom - rowTo).abs

    if rowDist != 1 && colDist != 1
      :illegal
    elsif rowDist == 1
      if colDist == 2
        dest_square = grid[rowTo][colTo]
        if dest_square.nil?
          :ok
        elsif dest_square.color == color
          :blocked
        else
          :capture
        end
      else
        :illegal
      end
    elsif rowDist == 2
      dest_square = grid[rowTo][colTo]
      if dest_square.nil?
        :ok
      elsif dest_square.color == color
        :blocked
      else
        :capture
      end
    else
      :illegal
    end
  end
end
