require_relative '../lib/board'
require_relative '../lib/pawn'
require_relative '../lib/king'

describe 'en passant' do
  context 'white en passant' do
    it 'allows white pawn to capture en passant to the left' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][4] = King.new(:white)  # e1
      grid[0][4] = King.new(:black)  # e8
      grid[3][4] = Pawn.new(:white)  # e5
      grid[1][3] = Pawn.new(:black)  # d7

      board.set_grid(grid)

      # Black pawn moves two squares (d7 → d5)
      board.move_piece([1, 3], [3, 3])
      board.en_passant_target = [2, 3] # mark target square behind d5

      result = board.move_piece([3, 4], [2, 3]) # e5 → d6 en passant

      expect(result).to eq(:ok)
      expect(board.grid[3][3]).to be_nil        # captured pawn removed
      expect(board.grid[2][3]).to be_a(Pawn)
      expect(board.grid[2][3].color).to eq(:white)
    end

    it 'does not allow en passant after one turn passes' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][4] = King.new(:white)
      grid[0][4] = King.new(:black)
      grid[3][4] = Pawn.new(:white)
      grid[1][3] = Pawn.new(:black)
      board.set_grid(grid)

      board.move_piece([1, 3], [3, 3]) # black pawn double move
      board.en_passant_target = [2, 3]
      board.en_passant_target = nil    # expired

      expect(board.move_piece([3, 4], [2, 3])).to eq(:illegal)
    end
  end

  context 'black en passant' do
    it 'allows black pawn to capture en passant to the right' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][4] = King.new(:white)
      grid[0][4] = King.new(:black)
      grid[4][3] = Pawn.new(:black) # d4
      grid[6][4] = Pawn.new(:white) # e2
      board.set_grid(grid)

      # White pawn double moves (e2 → e4)
      board.move_piece([6, 4], [4, 4])
      board.en_passant_target = [5, 4]

      result = board.move_piece([4, 3], [5, 4]) # d4 → e3 en passant

      expect(result).to eq(:ok)
      expect(board.grid[4][4]).to be_nil        # white pawn captured
      expect(board.grid[5][4]).to be_a(Pawn)
      expect(board.grid[5][4].color).to eq(:black)
    end

    it 'disallows en passant if pawn did not move two squares' do
      board = Board.new
      grid = Array.new(8) { Array.new(8) }

      grid[7][4] = King.new(:white)
      grid[0][4] = King.new(:black)
      grid[4][3] = Pawn.new(:black)
      grid[5][4] = Pawn.new(:white)
      board.set_grid(grid)

      board.en_passant_target = [5, 4] # fake target

      expect(board.move_piece([4, 3], [5, 4])).to eq(:illegal)
    end
  end
end
