require_relative './board'
require_relative './pawn'
require_relative './rook'
require_relative './knight'
require_relative './bishop'
require_relative './queen'
require_relative './king'

class Board
  STARTING_LAYOUT = [
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
      @grid[rowTo][colTo] = piece
      @grid[rowFrom][colFrom] = nil
    end

    result
  end

  def checkmate?(color)
    return false if is_check?(color) == false

    @grid.each_with_index do |row, i|
      row.each_with_index do |elem, j|
        return false if can_escape_check?(elem, i, j, color)
      end
    end
    true
  end

  def can_escape_check?(piece, row, col, color)
    (0...8).each do |i|
      (0...8).each do |j|
        next if i == row && j == col

        next unless move_piece([row, col], [i, j]) != :illegal

        board_copy = Marshal.load(Marshal.dump(@grid))
        board_copy[row][col] = nil
        board_copy[i][j] = piece

        return true if is_check?(color, grid) == false
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
        return true if piece.valid_move?([row_index, col_index], king_location, @grid) == :capture
      end
    end
    false
  end
end

board = Board.new
board.checkmate?(:black)
