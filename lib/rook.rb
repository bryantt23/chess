require_relative './piece'

class Rook < Piece
  def initialize(color)
    super(color)
    @display_name = 'R'
  end

  def valid_move?(from, to, grid = nil, _en_passant_target = nil)
    return :illegal if from == to

    if valid_straight?(from, to)
      clear_straight?(from, to, grid)
    else
      :illegal
    end
  end
end
