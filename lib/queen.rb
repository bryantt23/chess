require_relative './piece'

class Queen < Piece
  def initialize(color)
    super(color)
    @display_name = 'Q'
  end

  def valid_move?(from, to, grid = nil)
    return :illegal if from == to

    if valid_diagonal?(from, to)
      clear_diagonal = clear_diagonal?(from, to, grid)
      return clear_diagonal if clear_diagonal != :ok

      :ok
    elsif valid_straight?(from, to)
      clear_straight = clear_straight?(from, to, grid)
      return clear_straight if clear_straight != :ok

      :ok
    else
      :illegal
    end
  end
end
