# spec/check_spec.rb
require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/rook'
require_relative '../lib/king'
require_relative '../lib/bishop'
require_relative '../lib/pawn'

RSpec.describe 'Check detection with Rooks' do
  let(:board) { Board.new }

  describe 'White king in check' do
    it 'is in check from a black rook above' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[0][4] = Rook.new('Black')   # e8

      expect(board.is_check?('White')).to be true
    end

    it 'is in check from a black rook below' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[7][4] = Rook.new('Black')   # e1

      expect(board.is_check?('White')).to be true
    end

    it 'is in check from a black rook to the left' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[4][0] = Rook.new('Black')   # a4

      expect(board.is_check?('White')).to be true
    end

    it 'is in check from a black rook to the right' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[4][7] = Rook.new('Black')   # h4

      expect(board.is_check?('White')).to be true
    end

    it 'is not in check when a piece blocks the rook' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[0][4] = Rook.new('Black')
      board.grid[2][4] = Rook.new('White')   # block

      expect(board.is_check?('White')).to be false
    end

    it 'is not in check from a rook of the same color' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[0][4] = Rook.new('White')

      expect(board.is_check?('White')).to be false
    end
  end

  describe 'Black king in check' do
    it 'is in check from a white rook above' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')   # e4
      board.grid[0][4] = Rook.new('White')   # e8

      expect(board.is_check?('Black')).to be true
    end

    it 'is in check from a white rook below' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')   # e4
      board.grid[7][4] = Rook.new('White')   # e1

      expect(board.is_check?('Black')).to be true
    end

    it 'is in check from a white rook to the left' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')   # e4
      board.grid[4][0] = Rook.new('White')   # a4

      expect(board.is_check?('Black')).to be true
    end

    it 'is in check from a white rook to the right' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')   # e4
      board.grid[4][7] = Rook.new('White')   # h4

      expect(board.is_check?('Black')).to be true
    end

    it 'is not in check when a piece blocks the rook' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[0][4] = Rook.new('White')
      board.grid[2][4] = Rook.new('Black')   # block

      expect(board.is_check?('Black')).to be false
    end

    it 'is not in check from a rook of the same color' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('Black')
      board.grid[0][4] = Rook.new('Black')

      expect(board.is_check?('Black')).to be false
    end
  end
end

RSpec.describe 'Check detection with bishops' do
  let(:board) { Board.new }

  context 'White king in check by black bishop' do
    it 'detects check from top-left diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[0][0] = Bishop.new('Black') # a8
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from top-right diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[1][7] = Bishop.new('Black') # h8
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from bottom-left diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[7][1] = Bishop.new('Black') # b1
      expect(board.is_check?('White')).to be true
    end

    it 'detects check from bottom-right diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')   # e4
      board.grid[7][7] = Bishop.new('Black') # h1
      expect(board.is_check?('White')).to be true
    end

    it 'does not detect check when blocked by own piece' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[0][0] = Bishop.new('Black')
      board.grid[2][2] = Pawn.new('Black') # blocker
      expect(board.is_check?('White')).to be false
    end

    it 'does not detect check when diagonals don’t align' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[4][4] = King.new('White')
      board.grid[0][1] = Bishop.new('Black') # not aligned
      expect(board.is_check?('White')).to be false
    end
  end

  context 'Black king in check by white bishop' do
    it 'detects check from bottom-left diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[3][3] = King.new('Black')   # d5
      board.grid[7][7] = Bishop.new('White') # h1
      expect(board.is_check?('Black')).to be true
    end

    it 'detects check from top-right diagonal' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[3][3] = King.new('Black')   # d5
      board.grid[0][6] = Bishop.new('White') # g8
      expect(board.is_check?('Black')).to be true
    end

    it 'does not detect check when blocked' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[3][3] = King.new('Black')
      board.grid[0][0] = Bishop.new('White')
      board.grid[2][2] = Pawn.new('White') # blocker
      expect(board.is_check?('Black')).to be false
    end

    it 'does not detect check when not aligned' do
      board.grid = Array.new(8) { Array.new(8) }
      board.grid[3][3] = King.new('Black')
      board.grid[0][5] = Bishop.new('White') # off diagonal
      expect(board.is_check?('Black')).to be false
    end
  end
end
