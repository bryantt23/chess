class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def display
    "#{@color[0]}#{@display_name}"
  end
end
