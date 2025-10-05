require_relative './board'
require_relative './pawn'
require_relative './rook'
require_relative './knight'
require_relative './bishop'
require_relative './queen'
require_relative './king'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def set_grid(grid)
    @grid = grid
  end

  def setup_board
    @grid[0] =
      [Rook.new('Black'), Knight.new('Black'), Bishop.new('Black'), Queen.new('Black'), King.new('Black'),
       Bishop.new('Black'), Knight.new('Black'), Rook.new('Black')]

    @grid[1].each_with_index do |_elem, index|
      @grid[1][index] = Pawn.new('Black')
    end

    @grid[6].each_with_index do |_elem, index|
      @grid[6][index] = Pawn.new('White')
    end
    @grid[7] =
      [Rook.new('White'), Knight.new('White'), Bishop.new('White'), Queen.new('White'), King.new('White'),
       Bishop.new('White'), Knight.new('White'), Rook.new('White')]
  end

  def move_piece(from, to)
    colFrom = from[1]
    rowFrom = from[0]
    rowTo = to[0]
    colTo = to[1]

    piece = @grid[rowFrom][colFrom]
    return :illegal unless piece

    result = piece.valid_move?(from, to, @grid)

    if %i[ok capture].include?(result)
      @grid[rowTo][colTo] = piece
      @grid[rowFrom][colFrom] = nil
    end

    result
  end

  def is_check?(color)
    king_location = []
    @grid.each_with_index do |row, row_index|
      row.each_with_index do  |col, col_index|
        piece = col
        king_location = [row_index, col_index] if !piece.nil? && piece.color == color && piece.is_a?(King)
      end
    end

    @grid.each_with_index do |row, row_index|
      row.each_with_index do |_col, col_index|
        piece = grid[row_index][col_index]
        next unless !piece.nil? && piece.color != color
        return true if piece.valid_move?([row_index, col_index], king_location, @grid) == :capture
      end
    end
    false
  end
end
