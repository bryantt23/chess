require_relative './piece'

class Bishop < Piece
  def initialize(color)
    super(color)
    @display_name = 'B'
  end

  def valid_move?(from, to, grid = nil)
    return :illegal if from == to

    clear_diagonal = clear_diagonal?(from, to, grid)
    return clear_diagonal if clear_diagonal != :ok

    if valid_diagonal?(from, to)
      :ok
    else
      :illegal
    end
  end
end
