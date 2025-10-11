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
  attr_accessor :white_king_moved, :white_rook_kingside_moved,
                :white_rook_queenside_moved,
                :black_king_moved,
                :black_rook_kingside_moved,
                :black_rook_queenside_moved

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setup_board
    @white_king_moved = false
    @white_rook_kingside_moved = false
    @white_rook_queenside_moved = false
    @black_king_moved = false
    @black_rook_kingside_moved = false
    @black_rook_queenside_moved = false
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
    return castling_result(from, to) if is_castling_move?(from, to)

    colFrom = from[1]
    rowFrom = from[0]
    rowTo = to[0]
    colTo = to[1]

    piece = @grid[rowFrom][colFrom]
    return :illegal unless piece

    result = piece.valid_move?(from, to, @grid)

    if %i[ok capture].include?(result)
      return :illegal if causes_check?(from, to, @grid, piece)

      piece = Queen.new(piece.color) if is_promotion?(piece, to)

      if piece.is_a?(King)
        if piece.color == :white
          @white_king_moved = true
        else
          @black_king_moved = true
        end
      end

      if piece.is_a?(Rook)
        if piece.color == :white
          if from == [7, 7]
            @white_rook_kingside_moved = true
          elsif from == [7, 0]
            @white_rook_queenside_moved = true
          end
        elsif from == [0, 7] # black
          @black_rook_kingside_moved = true
        elsif from == [0, 0]
          @black_rook_queenside_moved = true
        end
      end

      @grid[rowTo][colTo] = piece
      @grid[rowFrom][colFrom] = nil
    end

    result
  end

  def is_promotion?(piece, to)
    if piece.is_a?(Pawn) == false
      false
    else
      to[0] == if piece.color == :white
                 0
               else
                 7
               end
    end
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

  def self.from_hash(hash)
    board = Board.new
    new_grid = hash.map do |row|
      row.map do |cell|
        if cell.nil?
          nil
        else
          Object.const_get(cell[:type]).new(cell[:color].to_sym)
        end
      end
    end
    board.set_grid(new_grid)
    board.white_king_moved = hash[:white_king_moved]
    board.white_rook_kingside_moved = hash[:white_rook_kingside_moved]
    board.white_rook_queenside_moved = hash[:white_rook_queenside_moved]
    board.black_king_moved = hash[:black_king_moved]
    board.black_rook_kingside_moved = hash[:black_rook_kingside_moved]
    board.black_rook_queenside_moved = hash[:black_rook_queenside_moved]

    board
  end

  def is_castling_move?(from, to)
    piece = @grid[from[0]][from[1]]
    return false unless piece.is_a?(King)

    (to[1] - from[1]).abs == 2
  end

  def castling_result(from, to)
    color = @grid[from[0]][from[1]].color
    row   = from[0]

    kingside = to[1] > from[1]
    rook_from = kingside ? [row, 7] : [row, 0]
    rook_to   = kingside ? [row, 5] : [row, 3]

    # --- Rule checks ---
    return :illegal if color == :white && @white_king_moved
    return :illegal if color == :black && @black_king_moved

    if color == :white
      return :illegal if kingside && @white_rook_kingside_moved
      return :illegal if !kingside && @white_rook_queenside_moved
    else
      return :illegal if kingside && @black_rook_kingside_moved
      return :illegal if !kingside && @black_rook_queenside_moved
    end

    # squares between king and rook must be empty
    min_col, max_col = [from[1], rook_from[1]].sort
    ((min_col + 1)...max_col).each do |col|
      return :illegal unless @grid[row][col].nil?
    end

    # king cannot be in or pass through check
    path_cols = kingside ? [from[1], from[1] + 1, from[1] + 2] : [from[1], from[1] - 1, from[1] - 2]
    path_cols.each do |col|
      temp = Marshal.load(Marshal.dump(@grid))
      temp[row][from[1]] = nil
      temp[row][col] = King.new(color)
      return :illegal if is_check?(color, temp)
    end

    # --- Perform castling ---
    king_piece = @grid[from[0]][from[1]]
    rook_piece = @grid[rook_from[0]][rook_from[1]]

    @grid[from[0]][from[1]] = nil
    @grid[rook_from[0]][rook_from[1]] = nil
    @grid[to[0]][to[1]] = king_piece
    @grid[rook_to[0]][rook_to[1]] = rook_piece

    if color == :white
      @white_king_moved = true
      kingside ? @white_rook_kingside_moved = true : @white_rook_queenside_moved = true
    else
      @black_king_moved = true
      kingside ? @black_rook_kingside_moved = true : @black_rook_queenside_moved = true
    end

    :ok
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
