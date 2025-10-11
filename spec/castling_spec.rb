require 'spec_helper'
require_relative '../lib/board'

# 🏰 CASTLING TESTS
describe 'castling' do
  context 'white castling' do
    it 'allows white kingside castle when all conditions met' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }
      grid[7][4] = King.new(:white)
      grid[7][7] = Rook.new(:white)
      grid[0][4] = King.new(:black)
      board.set_grid(grid)
      board.white_king_moved = false
      board.white_rook_kingside_moved = false

      result = board.move_piece([7, 4], [7, 6])
      expect(result).to eq(:ok)
      expect(board.grid[7][6]).to be_a(King)
      expect(board.grid[7][5]).to be_a(Rook)
    end

    it 'disallows kingside castle if white king has moved' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }
      grid[7][4] = King.new(:white)
      grid[7][7] = Rook.new(:white)
      grid[0][4] = King.new(:black)
      board.set_grid(grid)
      board.white_king_moved = true
      board.white_rook_kingside_moved = false

      expect(board.move_piece([7, 4], [7, 6])).to eq(:illegal)
    end

    it 'disallows kingside castle if white rook has moved' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }
      grid[7][4] = King.new(:white)
      grid[7][7] = Rook.new(:white)
      grid[0][4] = King.new(:black)
      board.set_grid(grid)
      board.white_king_moved = false
      board.white_rook_kingside_moved = true

      expect(board.move_piece([7, 4], [7, 6])).to eq(:illegal)
    end

    it 'disallows kingside castle if a piece is between king and rook' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }
      grid[7][4] = King.new(:white)
      grid[7][7] = Rook.new(:white)
      grid[7][5] = Bishop.new(:white)
      grid[0][4] = King.new(:black)
      board.set_grid(grid)
      board.white_king_moved = false
      board.white_rook_kingside_moved = false

      expect(board.move_piece([7, 4], [7, 6])).to eq(:illegal)
    end

    it 'disallows kingside castle if any square passed is under attack' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }
      grid[7][4] = King.new(:white)
      grid[7][7] = Rook.new(:white)
      grid[6][5] = Rook.new(:black) # attacks f1
      grid[0][4] = King.new(:black)
      board.set_grid(grid)
      board.white_king_moved = false
      board.white_rook_kingside_moved = false

      expect(board.move_piece([7, 4], [7, 6])).to eq(:illegal)
    end

    it 'allows white queenside castle when all conditions met' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }
      grid[7][4] = King.new(:white)
      grid[7][0] = Rook.new(:white)
      grid[0][4] = King.new(:black)
      board.set_grid(grid)
      board.white_king_moved = false
      board.white_rook_queenside_moved = false

      result = board.move_piece([7, 4], [7, 2])
      expect(result).to eq(:ok)
      expect(board.grid[7][2]).to be_a(King)
      expect(board.grid[7][3]).to be_a(Rook)
    end

    it 'disallows queenside castle if king passes through check' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }
      grid[7][4] = King.new(:white)
      grid[7][0] = Rook.new(:white)
      grid[6][3] = Rook.new(:black) # attacks d1
      grid[0][4] = King.new(:black)
      board.set_grid(grid)
      board.white_king_moved = false
      board.white_rook_queenside_moved = false

      expect(board.move_piece([7, 4], [7, 2])).to eq(:illegal)
    end
  end

  context 'black castling' do
    it 'allows black kingside castle when all conditions met' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }
      grid[0][4] = King.new(:black)
      grid[0][7] = Rook.new(:black)
      grid[7][4] = King.new(:white)
      board.set_grid(grid)
      board.black_king_moved = false
      board.black_rook_kingside_moved = false

      result = board.move_piece([0, 4], [0, 6])
      expect(result).to eq(:ok)
      expect(board.grid[0][6]).to be_a(King)
      expect(board.grid[0][5]).to be_a(Rook)
    end

    it 'disallows black kingside castle if king in check' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }
      grid[0][4] = King.new(:black)
      grid[0][7] = Rook.new(:black)
      grid[1][4] = Rook.new(:white) # attacks e8
      grid[7][4] = King.new(:white)
      board.set_grid(grid)
      board.black_king_moved = false
      board.black_rook_kingside_moved = false

      expect(board.move_piece([0, 4], [0, 6])).to eq(:illegal)
    end

    it 'disallows black queenside castle if rook has moved' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }
      grid[0][4] = King.new(:black)
      grid[0][0] = Rook.new(:black)
      grid[7][4] = King.new(:white)
      board.set_grid(grid)
      board.black_king_moved = false
      board.black_rook_queenside_moved = true

      expect(board.move_piece([0, 4], [0, 2])).to eq(:illegal)
    end
  end
end
