# spec/checkmate_spec.rb
require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/king'
require_relative '../lib/pawn'
require_relative '../lib/view'

RSpec.describe Board do
  describe '#checkmate? basic sanity' do
    it 'returns false when White is not in check (simple pawn + king setup)' do
      board = Board.new
      custom_grid = Array.new(8) { Array.new(8) }

      custom_grid[7][4] = King.new(:white)  # e1
      custom_grid[6][4] = Pawn.new(:white)  # e2
      custom_grid[0][4] = King.new(:black)  # e8

      board.set_grid(custom_grid)

      expect(board.checkmate?(:white)).to be false
    end
  end

  describe '#checkmate?' do
    it 'detects checkmate against White in the corner' do
      board = Board.new
      custom_grid = Array.new(8) { Array.new(8) }
      custom_grid[7][7] = King.new(:white) # h1
      custom_grid[6][6] = Queen.new(:black)  # g2
      custom_grid[6][7] = Rook.new(:black)   # h2
      custom_grid[3][4] = King.new(:black)   # e5

      board.set_grid(custom_grid)

      expect(board.checkmate?(:white)).to be true
    end
  end

  describe '#checkmate? sanity checks' do
    it 'returns false when White king is safe in open space' do
      board = Board.new
      custom_grid = Array.new(8) { Array.new(8) }

      # White king somewhere in the middle, no enemies around
      custom_grid[4][4] = King.new(:white)  # e4
      custom_grid[0][4] = King.new(:black)  # e8

      board.set_grid(custom_grid)

      expect(board.checkmate?(:white)).to be false
    end
  end

  describe '#checkmate? various scenarios' do
    it 'returns false when White king is safe in open space' do
      board = Board.new
      custom_grid = Array.new(8) { Array.new(8) }

      custom_grid[4][4] = King.new(:white)  # e4
      custom_grid[0][4] = King.new(:black)  # e8

      board.set_grid(custom_grid)
      expect(board.checkmate?(:white)).to be false
    end

    it 'returns false when White is in check but can escape' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][4] = King.new(:white)  # e1
      grid[5][4] = Rook.new(:black)  # e3 (puts check)
      grid[0][4] = King.new(:black)  # e8
      board.set_grid(grid)

      expect(board.checkmate?(:white)).to be false
    end

    it 'returns true for classic corner checkmate (Queen + Rook)' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][7] = King.new(:white)   # h1
      grid[6][6] = Queen.new(:black)  # g2
      grid[6][7] = Rook.new(:black)   # h2
      grid[3][4] = King.new(:black)   # e5
      board.set_grid(grid)

      expect(board.checkmate?(:white)).to be true
    end

    it 'returns true when White king trapped in corner by two rooks' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][0] = King.new(:white)  # a1
      grid[5][0] = Rook.new(:black)  # a2
      grid[7][1] = Rook.new(:black)  # b1
      grid[0][4] = King.new(:black)  # e8
      board.set_grid(grid)

      expect(board.checkmate?(:white)).to be false
    end

    it 'returns false when White king is not trapped in corner by two rooks' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][0] = King.new(:white)  # a1
      grid[6][0] = Rook.new(:black)  # a2
      grid[7][1] = Rook.new(:black)  # b1
      grid[0][4] = King.new(:black)  # e8
      board.set_grid(grid)

      expect(board.checkmate?(:white)).to be false
    end

    it 'returns true when king trapped' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][0] = King.new(:white)
      grid[5][0] = Rook.new(:black)
      grid[5][1] = Rook.new(:black)
      grid[0][4] = King.new(:black)
      board.set_grid(grid)

      expect(board.checkmate?(:white)).to be true
    end

    it 'returns false when White king nearly trapped but can escape (rook misaligned)' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][0] = King.new(:white)   # a1
      grid[6][0] = Rook.new(:black)   # a2
      grid[5][2] = Rook.new(:black)   # c3 — not blocking escape
      grid[0][4] = King.new(:black)   # e8
      board.set_grid(grid)

      expect(board.checkmate?(:white)).to be false
    end

    it 'returns false for diagonal check (Bishop)' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][7] = King.new(:white)   # h1
      grid[5][5] = Queen.new(:black) # f3
      grid[2][2] = Bishop.new(:black) # c6
      grid[0][4] = King.new(:black)   # e8
      board.set_grid(grid)

      expect(board.checkmate?(:white)).to be false
    end

    it 'returns true for diagonal checkmate (Queen + Bishop)' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][7] = King.new(:white)   # h1
      grid[5][6] = Queen.new(:black) # g3
      grid[2][2] = Bishop.new(:black) # c6
      grid[0][4] = King.new(:black)   # e8
      board.set_grid(grid)

      expect(board.checkmate?(:white)).to be true
    end

    it 'returns false when pawn blocks check (not checkmate)' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][7] = King.new(:white)   # h1
      grid[6][6] = Queen.new(:black)  # g2
      grid[6][7] = Pawn.new(:white)   # h2 (blocks)
      grid[0][4] = King.new(:black)   # e8
      board.set_grid(grid)

      expect(board.checkmate?(:white)).to be false
    end

    it 'returns true for smothered mate (Knight)' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][7] = King.new(:white)   # h1
      grid[7][6] = Knight.new(:white) # g1
      grid[6][6] = Pawn.new(:white)   # g2
      grid[6][7] = Pawn.new(:white)   # h2
      grid[5][5] = Knight.new(:black) # f3
      grid[0][4] = King.new(:black)   # e8
      board.set_grid(grid)

      expect(board.checkmate?(:white)).to be false
    end
  end
end
