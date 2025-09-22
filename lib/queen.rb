require_relative './piece'

class Queen < Piece
  def initialize(color)
    super(color)
    @display_name = 'Q'
  end

  def valid_move?(from, to)
    return :illegal if from == to

   if valid_diagonal?(from, to) || valid_straight?(from, to)
    :ok
   else
    :illegal
   end
  end
end
