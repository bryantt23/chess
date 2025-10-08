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

  it 'returns false when White is in check but can escape sideways' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    grid[7][0] = King.new(:white)  # a1
    grid[5][0] = Rook.new(:black)  # a3
    grid[0][4] = King.new(:black)  # e8
    board.set_grid(grid)

    expect(board.checkmate?(:white)).to be false
  end

  it 'returns true for Anastasia’s mate (rook + knight vs king + pawn)' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    grid[1][7] = King.new(:black)    # h7
    grid[1][6] = Pawn.new(:black)    # g7
    grid[1][4] = Knight.new(:white)  # e7
    grid[3][7] = Rook.new(:white)    # h5

    board.set_grid(grid)
    expect(board.checkmate?(:black)).to be true
  end

  it 'detects back-rank mate (rook on 8th rank, king trapped by pawns)' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    # Board visualization reference (row 0 = top):
    # 0 a8 b8 c8 d8 e8 f8 g8 h8
    #                 ♖(white rook)e8  ♚(black king)g8
    # 1 a7 b7 c7 d7 e7 f7 g7 h7
    #                    ♟(black pawns) f7 g7 h7
    # White pieces from bottom (row 7)
    grid[0][4] = Rook.new(:white)    # e8
    grid[0][6] = King.new(:black)    # g8
    grid[1][5] = Pawn.new(:black)    # f7
    grid[1][6] = Pawn.new(:black)    # g7
    grid[1][7] = Pawn.new(:black)    # h7
    grid[7][4] = King.new(:white)    # e1 (to satisfy board)

    board.set_grid(grid)

    expect(board.checkmate?(:black)).to be true
  end

  it 'detects Arabian mate (rook + knight corner checkmate)' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    # Board reference:
    # 0  a8 b8 c8 d8 e8 f8 g8 h8
    #                        ♚(black king) h8
    # 1  a7 b7 c7 d7 e7 f7 g7 h7
    #                          ♖(white rook) h7
    # 2  a6 b6 c6 d6 e6 f6 g6 h6
    #                      ♘(white knight) f6
    # White king to complete board
    grid[0][7] = King.new(:black)     # h8
    grid[1][7] = Rook.new(:white)     # h7
    grid[2][5] = Knight.new(:white)   # f6
    grid[7][4] = King.new(:white)     # e1

    board.set_grid(grid)

    expect(board.checkmate?(:black)).to be true
  end
end
