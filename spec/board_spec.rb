# spec/board_spec.rb
require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/pawn'
require_relative '../lib/rook'
require_relative '../lib/knight'
require_relative '../lib/bishop'
require_relative '../lib/queen'
require_relative '../lib/king'

RSpec.describe Board do
  let(:board) { Board.new }

  describe '#setup_board' do
    before(:each) { board.setup_board }

    it 'places black pawns on row 2' do
      (0..7).each do |col|
        piece = board.grid[1][col]
        expect(piece).to be_a(Pawn)
        expect(piece.color).to eq('Black')
      end
    end

    it 'places white pawns on row 7' do
      (0..7).each do |col|
        piece = board.grid[6][col]
        expect(piece).to be_a(Pawn)
        expect(piece.color).to eq('White')
      end
    end

    it 'places black major pieces on row 1' do
      row = board.grid[0]
      expect(row.map(&:class)).to eq(
        [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      )
      expect(row.map(&:color).uniq).to eq(['Black'])
    end

    it 'places white major pieces on row 8' do
      row = board.grid[7]
      expect(row.map(&:class)).to eq(
        [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      )
      expect(row.map(&:color).uniq).to eq(['White'])
    end
  end

  describe '#move_piece basic moves' do
    before(:each) { board.setup_board }

    it 'moves a white pawn forward one square' do
      board.move_piece([6, 4], [5, 4])
      expect(board.grid[5][4]).to be_a(Pawn)
      expect(board.grid[5][4].color).to eq('White')
      expect(board.grid[6][4]).to be_nil
    end

    it 'lets white move a pawn and black move a knight' do
      board.move_piece([6, 4], [5, 4])
      board.move_piece([0, 1], [2, 2])

      expect(board.grid[5][4]).to be_a(Pawn)
      expect(board.grid[6][4]).to be_nil
      expect(board.grid[2][2]).to be_a(Knight)
      expect(board.grid[0][1]).to be_nil
    end
  end

  describe '#move_piece with Rook movement' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    it 'allows a valid horizontal move for a rook' do
      board.grid[4][4] = Rook.new('White')
      result = board.move_piece([4, 4], [4, 7])
      expect(result).to eq(:ok)
      expect(board.grid[4][7]).to be_a(Rook)
      expect(board.grid[4][4]).to be_nil
    end

    it 'rejects an invalid diagonal move for a rook' do
      board.grid[4][4] = Rook.new('White')
      result = board.move_piece([4, 4], [6, 6])
      expect(result).to eq(:illegal)
      expect(board.grid[4][4]).to be_a(Rook)
      expect(board.grid[6][6]).to be_nil
    end
  end

  describe '#move_piece with Bishop movement' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    it 'allows a valid diagonal move for a bishop' do
      board.grid[4][4] = Bishop.new('White')
      result = board.move_piece([4, 4], [2, 2])
      expect(result).to eq(:ok)
      expect(board.grid[2][2]).to be_a(Bishop)
      expect(board.grid[4][4]).to be_nil
    end

    it 'rejects an invalid straight move for a bishop' do
      board.grid[4][4] = Bishop.new('White')
      result = board.move_piece([4, 4], [4, 5])
      expect(result).to eq(:illegal)
      expect(board.grid[4][4]).to be_a(Bishop)
      expect(board.grid[4][5]).to be_nil
    end
  end

  describe '#move_piece with Queen movement' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    it 'allows a valid diagonal move for a queen' do
      board.grid[3][3] = Queen.new('White')
      result = board.move_piece([3, 3], [6, 6])
      expect(result).to eq(:ok)
      expect(board.grid[6][6]).to be_a(Queen)
      expect(board.grid[3][3]).to be_nil
    end

    it 'rejects an invalid L-shaped move for a queen' do
      board.grid[3][3] = Queen.new('White')
      result = board.move_piece([3, 3], [5, 4])
      expect(result).to eq(:illegal)
      expect(board.grid[3][3]).to be_a(Queen)
      expect(board.grid[5][4]).to be_nil
    end
  end

  describe '#move_piece with King movement' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    it 'allows a valid one-square move for a king' do
      board.grid[4][4] = King.new('White')
      result = board.move_piece([4, 4], [5, 5])
      expect(result).to eq(:ok)
      expect(board.grid[5][5]).to be_a(King)
      expect(board.grid[4][4]).to be_nil
    end

    it 'rejects a move more than one square for a king' do
      board.grid[4][4] = King.new('White')
      result = board.move_piece([4, 4], [6, 4])
      expect(result).to eq(:illegal)
      expect(board.grid[4][4]).to be_a(King)
      expect(board.grid[6][4]).to be_nil
    end
  end

  describe '#move_piece with Knight movement' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    it 'allows a valid L-shaped move for a knight' do
      board.grid[4][4] = Knight.new('White')
      result = board.move_piece([4, 4], [6, 5])
      expect(result).to eq(:ok)
      expect(board.grid[6][5]).to be_a(Knight)
      expect(board.grid[4][4]).to be_nil
    end

    it 'rejects a diagonal move for a knight' do
      board.grid[4][4] = Knight.new('White')
      result = board.move_piece([4, 4], [5, 5])
      expect(result).to eq(:illegal)
      expect(board.grid[4][4]).to be_a(Knight)
      expect(board.grid[5][5]).to be_nil
    end
  end

  describe '#move_piece with Pawn movement' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    it 'allows a valid one-square forward move for a pawn' do
      board.grid[6][4] = Pawn.new('White')
      result = board.move_piece([6, 4], [5, 4])
      expect(result).to eq(:ok)
      expect(board.grid[5][4]).to be_a(Pawn)
      expect(board.grid[6][4]).to be_nil
    end

    it 'rejects a sideways move for a pawn' do
      board.grid[6][4] = Pawn.new('White')
      result = board.move_piece([6, 4], [6, 5])
      expect(result).to eq(:illegal)
      expect(board.grid[6][4]).to be_a(Pawn)
      expect(board.grid[6][5]).to be_nil
    end
  end

  describe '#move_piece with Rook blockers' do
    before(:each) { board.grid = Array.new(8) { Array.new(8) } }

    # ↓ down
    it 'rejects a rook move down when a piece blocks the path' do
      board.grid[0][0] = Rook.new('White')
      board.grid[3][0] = Pawn.new('White')
      result = board.move_piece([0, 0], [7, 0])
      expect(result).to eq(:blocked)
    end

    it 'allows a rook move down if clear' do
      board.grid[0][0] = Rook.new('White')
      result = board.move_piece([0, 0], [7, 0])
      expect(result).to eq(:ok)
    end

    # ↑ up
    it 'rejects a rook move up when a piece blocks the path' do
      board.grid[7][0] = Rook.new('White')
      board.grid[4][0] = Pawn.new('White')
      result = board.move_piece([7, 0], [0, 0])
      expect(result).to eq(:blocked)
    end

    it 'allows a rook move up if clear' do
      board.grid[7][0] = Rook.new('White')
      result = board.move_piece([7, 0], [0, 0])
      expect(result).to eq(:ok)
    end

    # → right
    it 'rejects a rook move right when a piece blocks the path' do
      board.grid[0][0] = Rook.new('White')
      board.grid[0][3] = Pawn.new('White')
      result = board.move_piece([0, 0], [0, 7])
      expect(result).to eq(:blocked)
    end

    it 'allows a rook move right if clear' do
      board.grid[0][0] = Rook.new('White')
      result = board.move_piece([0, 0], [0, 7])
      expect(result).to eq(:ok)
    end

    # ← left
    it 'rejects a rook move left when a piece blocks the path' do
      board.grid[0][7] = Rook.new('White')
      board.grid[0][4] = Pawn.new('White')
      result = board.move_piece([0, 7], [0, 0])
      expect(result).to eq(:blocked)
    end

    it 'allows a rook move left if clear' do
      board.grid[0][7] = Rook.new('White')
      result = board.move_piece([0, 7], [0, 0])
      expect(result).to eq(:ok)
    end
  end
end
