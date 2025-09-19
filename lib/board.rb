require_relative './board'
require_relative './pawn'
require_relative './rook'
require_relative './knight'
require_relative './bishop'
require_relative './queen'
require_relative './king'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def setup_board
    @grid[0] =
      [Rook.new('White'), Knight.new('White'), Bishop.new('White'), Queen.new('White'), King.new('White'),
       Bishop.new('White'), Knight.new('White'), Rook.new('White')]
    @grid[1].each_with_index do |_elem, index|
      @grid[1][index] = Pawn.new('White')
    end
    @grid[6].each_with_index do |_elem, index|
      @grid[6][index] = Pawn.new('Black')
    end
    @grid[7] =
      [Rook.new('Black'), Knight.new('Black'), Bishop.new('Black'), Queen.new('Black'), King.new('Black'),
       Bishop.new('Black'), Knight.new('Black'), Rook.new('Black')]
  end
end
