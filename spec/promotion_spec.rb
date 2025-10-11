require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/pawn'
require_relative '../lib/queen'
require_relative '../lib/king'

RSpec.describe 'Pawn Promotion' do
  it 'promotes a white pawn to a queen when reaching the last rank' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    grid[1][0] = Pawn.new(:white)
    grid[7][4] = King.new(:white)
    grid[0][4] = King.new(:black)
    board.set_grid(grid)

    board.move_piece([1, 0], [0, 0])

    expect(board.grid[0][0]).to be_a(Queen)
    expect(board.grid[0][0].color).to eq(:white)
  end

  it 'promotes a black pawn to a queen when reaching the last rank' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    grid[6][7] = Pawn.new(:black)
    grid[7][4] = King.new(:white)
    grid[0][4] = King.new(:black)
    board.set_grid(grid)

    board.move_piece([6, 7], [7, 7])

    expect(board.grid[7][7]).to be_a(Queen)
    expect(board.grid[7][7].color).to eq(:black)
  end

  it 'does not promote if pawn has not reached the last rank' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    grid[3][3] = Pawn.new(:white)
    grid[7][4] = King.new(:white)
    grid[0][4] = King.new(:black)
    board.set_grid(grid)

    board.move_piece([3, 3], [2, 3])

    expect(board.grid[2][3]).to be_a(Pawn)
    expect(board.grid[2][3].color).to eq(:white)
  end

  it 'promotes when capturing diagonally on the last rank' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    grid[1][1] = Pawn.new(:white)
    grid[0][2] = Rook.new(:black)
    grid[7][4] = King.new(:white)
    grid[0][4] = King.new(:black)
    board.set_grid(grid)

    board.move_piece([1, 1], [0, 2])

    expect(board.grid[0][2]).to be_a(Queen)
    expect(board.grid[0][2].color).to eq(:white)
  end

  it 'keeps the game flow valid after promotion' do
    board = Board.new
    grid = Array.new(8) { Array.new(8) }

    grid[1][0] = Pawn.new(:white)
    grid[7][4] = King.new(:white)
    grid[0][4] = King.new(:black)
    board.set_grid(grid)

    result = board.move_piece([1, 0], [0, 0])

    expect(result).not_to eq(:illegal)
    expect(board.grid[0][0]).to be_a(Queen)
  end
end
