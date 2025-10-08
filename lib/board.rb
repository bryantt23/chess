require_relative './board'
require_relative './pawn'
require_relative './rook'
require_relative './knight'
require_relative './bishop'
require_relative './queen'
require_relative './king'

class Board
  STARTING_LAYOUT ||= [
    %i[rook knight bishop queen king bishop knight rook].map { |p| [p, :black] },
    Array.new(8) { %i[pawn black] },
    Array.new(8) { nil },
    Array.new(8) { nil },
    Array.new(8) { nil },
    Array.new(8) { nil },
    Array.new(8) { %i[pawn white] },
    %i[rook knight bishop queen king bishop knight rook].map { |p| [p, :white] }
  ].freeze

  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setup_board
  end

  def set_grid(grid)
    @grid = grid
  end

  def setup_board
    @grid = STARTING_LAYOUT.map do |row|
      row.map do |cell|
        next nil unless cell

        piece_type, color = cell
        Object.const_get(piece_type.to_s.capitalize).new(color)
      end
    end
  end

  def board_pure?
    STARTING_LAYOUT.each_with_index.all? do |row, r|
      row.each_with_index.all? do |cell, c|
        piece = @grid[r][c]
        if cell.nil?
          piece.nil?
        else
          type, color = cell
          piece.is_a?(Object.const_get(type.to_s.capitalize)) && piece.color == color
        end
      end
    end
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
      return :illegal if causes_check?(from, to, @grid, piece)

      @grid[rowTo][colTo] = piece
      @grid[rowFrom][colFrom] = nil
    end

    result
  end

  def causes_check?(from, to, grid, piece)
    colFrom = from[1]
    rowFrom = from[0]
    rowTo = to[0]
    colTo = to[1]

    board_copy = Marshal.load(Marshal.dump(grid))
    board_copy[rowTo][colTo] = piece
    board_copy[rowFrom][colFrom] = nil

    is_check?(piece.color, board_copy)
  end

  def checkmate?(color)
    return false if is_check?(color) == false

    @grid.each_with_index do |row, i|
      row.each_with_index do |elem, j|
        return false if !elem.nil? && elem.color == color && can_escape_check?(elem, i, j, color)
      end
    end
    true
  end

  def can_escape_check?(piece, row, col, color)
    (0...8).each do |i|
      (0...8).each do |j|
        next if i == row && j == col

        board_copy = Marshal.load(Marshal.dump(@grid))
        result = piece.valid_move?([row, col], [i, j], board_copy)
        next unless %i[ok capture].include?(result)

        board_copy[row][col] = nil
        board_copy[i][j] = piece

        return true unless is_check?(color, board_copy)
      end
    end

    false
  end

  def is_check?(color, grid = @grid)
    king_location = []
    grid.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        piece = col
        king_location = [row_index, col_index] if !piece.nil? && piece.color == color && piece.is_a?(King)
      end
    end

    grid.each_with_index do |row, row_index|
      row.each_with_index do |_col, col_index|
        piece = grid[row_index][col_index]
        next unless !piece.nil? && piece.color != color
        return true if piece.valid_move?([row_index, col_index], king_location, grid) == :capture
      end
    end
    false
  end
end

# grid = Array.new(8) { Array.new(8) }
# board = Board.new
# grid[7][0] = King.new(:white) # a1
# grid[6][0] = Rook.new(:black) # a2
# grid[5][2] = Rook.new(:black) # c3
# grid[0][4] = King.new(:black) # e8
# board.set_grid(grid)
# puts "#{board.checkmate?(:white)}"

# board = Board.new
# grid = Array.new(8) { Array.new(8) }

# grid[7][0] = King.new(:white)   # a1
# grid[6][0] = Rook.new(:black)   # a2
# grid[5][2] = Rook.new(:black)   # c3
# grid[0][4] = King.new(:black)   # e8
# board.set_grid(grid)
# puts "hii #{board.checkmate?(:white)}"

# board = Board.new
# grid = Array.new(8) { Array.new(8) }

# grid[7][7] = King.new(:white) # h1
# grid[5][5] = Queen.new(:black) # f3
# grid[2][2] = Bishop.new(:black) # c6
# grid[0][4] = King.new(:black)   # e8
# board.set_grid(grid)

# puts "hii #{board.checkmate?(:white)}"

# board = Board.new
# grid = Array.new(8) { Array.new(8) }
# grid[0][7] = King.new(:black)     # h8
# grid[1][7] = Rook.new(:white)     # h7
# grid[2][5] = Knight.new(:white)   # f6
# grid[7][4] = King.new(:white)     # e1

# board.set_grid(grid)
# board.checkmate?(:black)
