# spec/checkmate_spec.rb
require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/king'
require_relative '../lib/pawn'

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
end
