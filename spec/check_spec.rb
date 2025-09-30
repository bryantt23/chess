# spec/check_spec.rb
require 'spec_helper'
require_relative '../lib/board'
require_relative '../lib/rook'
require_relative '../lib/king'

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
