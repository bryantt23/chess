require_relative './piece'

class Rook < Piece
  def initialize(color)
    super(color)
    @display_name = 'R'
  end

  def valid_move?(from, to)
    return :illegal if from == to

    if valid_straight?(from, to)
      :ok
    else
      :illegal
    end
  end
end
