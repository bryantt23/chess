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

    if result == :ok
      @grid[rowTo][colTo] = piece
      @grid[rowFrom][colFrom] = nil
      :ok
    else
      result
    end
  end
end



# require_relative 'board'
# require_relative 'pawn'

# board = Board.new
# board.grid = Array.new(8) { Array.new(8) } # fresh empty board

# # --- White pawn, 1-square forward blocked ---
# board.grid[6][4] = Pawn.new('White') # e2
# board.grid[5][4] = Pawn.new('White') # blocking at e3

# result = board.move_piece([6, 4], [5, 4])
# puts "White pawn blocked (expect :blocked): #{result}"
# puts "e2 still has Pawn? #{board.grid[6][4].is_a?(Pawn)}"
# puts "e3 still has Pawn? #{board.grid[5][4].is_a?(Pawn)}"

# # --- Reset board ---
# board.grid = Array.new(8) { Array.new(8) }
# board.grid[6][4] = Pawn.new('White')
# board.grid[5][4] = Pawn.new('Black')

# result = board.move_piece([6, 4], [4, 4]) # e2 → e4
# puts "White pawn blocked at intermediate square (expect :blocked): #{result}"
# puts "e2 still has Pawn? #{board.grid[6][4].is_a?(Pawn)}"
# puts "e4 empty? #{board.grid[4][4].nil?}"

# # --- Reset board ---
# board.grid = Array.new(8) { Array.new(8) }
# board.grid[6][4] = Pawn.new('White')
# board.grid[4][4] = Pawn.new('Black')

# result = board.move_piece([6, 4], [4, 4]) # e2 → e4
# puts "White pawn blocked at destination (expect :blocked): #{result}"
# puts "e2 still has Pawn? #{board.grid[6][4].is_a?(Pawn)}"
# puts "e4 still has Pawn? #{board.grid[4][4].is_a?(Pawn)}"

# # --- Reset board ---
# board.grid = Array.new(8) { Array.new(8) }
# board.grid[6][4] = Pawn.new('White')

# result = board.move_piece([6, 4], [4, 4]) # e2 → e4
# puts "White pawn 2-square clear (expect :ok): #{result}"
# puts "e4 has Pawn? #{board.grid[4][4].is_a?(Pawn)}"
# puts "e2 empty? #{board.grid[6][4].nil?}"

# # --- Reset board ---
# board.grid = Array.new(8) { Array.new(8) }
# board.grid[1][4] = Pawn.new('Black') # e7
# board.grid[2][4] = Pawn.new('Black') # blocking at e6

# result = board.move_piece([1, 4], [2, 4])
# puts "Black pawn blocked (expect :blocked): #{result}"
# puts "e7 still has Pawn? #{board.grid[1][4].is_a?(Pawn)}"
# puts "e6 still has Pawn? #{board.grid[2][4].is_a?(Pawn)}"
