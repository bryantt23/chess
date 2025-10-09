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

  it 'disallows a pinned piece from moving and exposing its king to check' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    grid[7][4] = King.new(:white)   # e1
    grid[5][4] = Rook.new(:white)   # e3 (pinned)
    grid[2][4] = Rook.new(:black)   # e6
    grid[0][4] = King.new(:black)   # e8
    board.set_grid(grid)

    result = board.move_piece([5, 4], [5, 5]) # move rook sideways → exposes king
    expect(result).to eq(:illegal)
  end

  it 'allows a pinned rook to move along the pin line' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    grid[7][4] = King.new(:white)   # e1
    grid[5][4] = Rook.new(:white)   # e3
    grid[2][4] = Rook.new(:black)   # e6
    grid[0][4] = King.new(:black)   # e8
    board.set_grid(grid)

    result = board.move_piece([5, 4], [6, 4]) # up/down along pin line
    expect(result).to eq(:ok)
  end

  it 'disallows bishop from moving off diagonal pin line' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    grid[7][2] = King.new(:white)   # c1
    grid[5][4] = Bishop.new(:white) # e3
    grid[3][6] = Bishop.new(:black) # g5
    grid[0][6] = King.new(:black)   # g8
    board.set_grid(grid)

    result = board.move_piece([5, 4], [4, 3]) # e3 → d4 (off diagonal)
    expect(result).to eq(:illegal)
  end

  it 'disallows knight from moving if it exposes king to check' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    grid[7][4] = King.new(:white)   # e1
    grid[6][2] = Knight.new(:white) # c2
    grid[4][4] = Rook.new(:black)   # e4
    grid[0][4] = King.new(:black)   # e8
    board.set_grid(grid)

    result = board.move_piece([6, 2], [4, 3]) # c2 → d4 exposes king on file
    expect(result).to eq(:illegal)
  end

  it 'disallows pawn capture that exposes its king' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    grid[7][4] = King.new(:white)   # e1
    grid[6][3] = Pawn.new(:white)   # d2
    grid[4][4] = Rook.new(:black)   # e4
    grid[5][2] = Pawn.new(:black)   # c3 target
    grid[0][4] = King.new(:black)   # e8
    board.set_grid(grid)

    result = board.move_piece([6, 3], [5, 2]) # d2 → c3 exposes e-file
    expect(result).to eq(:illegal)
  end
end
