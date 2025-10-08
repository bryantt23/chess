# spec/self_check_spec.rb
require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/king'
require_relative '../lib/rook'
require_relative '../lib/view'

RSpec.describe Board do
  describe '#valid_move? (self-check prevention)' do
    it 'disallows king from moving into a rook’s line of attack' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[6][4] = King.new(:white)   # e2
      grid[4][4] = Rook.new(:black)   # e4
      grid[0][4] = King.new(:black)   # e8
      board.set_grid(grid)

      result = board.move_piece([6, 4], [5, 4]) # move into e3 — should be illegal
      expect(result).to eq(:illegal)
    end

    it 'allows king to move sideways when not in check' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[6][4] = King.new(:white)   # e2
      grid[4][4] = Rook.new(:black)   # e4
      grid[0][4] = King.new(:black)   # e8
      board.set_grid(grid)

      result = board.move_piece([6, 4], [6, 5]) # e2 → f2, sideways, safe
      expect(result).to eq(:ok)
    end
  end
end
