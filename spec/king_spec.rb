# spec/king_spec.rb
require 'spec_helper'
require_relative '../lib/king'
require_relative '../lib/pawn'

RSpec.describe King do
  let(:king) { King.new('White') }
  let(:empty_grid) { Array.new(8) { Array.new(8) } }

  context 'valid moves' do
    it 'can move one square up' do
      expect(king.valid_move?([4, 4], [5, 4], empty_grid)).to eq(:ok)
    end

    it 'can move one square down' do
      expect(king.valid_move?([4, 4], [3, 4], empty_grid)).to eq(:ok)
    end

    it 'can move one square left' do
      expect(king.valid_move?([4, 4], [4, 3], empty_grid)).to eq(:ok)
    end

    it 'can move one square right' do
      expect(king.valid_move?([4, 4], [4, 5], empty_grid)).to eq(:ok)
    end

    it 'can move one square diagonally' do
      expect(king.valid_move?([4, 4], [5, 5], empty_grid)).to eq(:ok)
      expect(king.valid_move?([4, 4], [5, 3], empty_grid)).to eq(:ok)
      expect(king.valid_move?([4, 4], [3, 5], empty_grid)).to eq(:ok)
      expect(king.valid_move?([4, 4], [3, 3], empty_grid)).to eq(:ok)
    end
  end

  context 'invalid moves' do
    it 'cannot move more than one square' do
      expect(king.valid_move?([4, 4], [6, 4], empty_grid)).to eq(:illegal)
      expect(king.valid_move?([4, 4], [4, 6], empty_grid)).to eq(:illegal)
      expect(king.valid_move?([4, 4], [6, 6], empty_grid)).to eq(:illegal)
    end

    it 'cannot stay in place' do
      expect(king.valid_move?([4, 4], [4, 4], empty_grid)).to eq(:illegal)
    end

    describe 'King blockers (same color)' do
      it 'cannot move up into a same-color piece' do
        grid = Array.new(8) { Array.new(8) }
        grid[4][4] = King.new('White')
        grid[5][4] = Pawn.new('White')

        result = grid[4][4].valid_move?([4, 4], [5, 4], grid)
        expect(result).to eq(:blocked)
      end

      it 'cannot move down into a same-color piece' do
        grid = Array.new(8) { Array.new(8) }
        grid[4][4] = King.new('White')
        grid[3][4] = Pawn.new('White')

        result = grid[4][4].valid_move?([4, 4], [3, 4], grid)
        expect(result).to eq(:blocked)
      end

      it 'cannot move left into a same-color piece' do
        grid = Array.new(8) { Array.new(8) }
        grid[4][4] = King.new('White')
        grid[4][3] = Pawn.new('White')

        result = grid[4][4].valid_move?([4, 4], [4, 3], grid)
        expect(result).to eq(:blocked)
      end

      it 'cannot move right into a same-color piece' do
        grid = Array.new(8) { Array.new(8) }
        grid[4][4] = King.new('White')
        grid[4][5] = Pawn.new('White')

        result = grid[4][4].valid_move?([4, 4], [4, 5], grid)
        expect(result).to eq(:blocked)
      end

      it 'cannot move diagonally up-right into a same-color piece' do
        grid = Array.new(8) { Array.new(8) }
        grid[4][4] = King.new('White')
        grid[5][5] = Pawn.new('White')

        result = grid[4][4].valid_move?([4, 4], [5, 5], grid)
        expect(result).to eq(:blocked)
      end

      it 'cannot move diagonally up-left into a same-color piece' do
        grid = Array.new(8) { Array.new(8) }
        grid[4][4] = King.new('White')
        grid[5][3] = Pawn.new('White')

        result = grid[4][4].valid_move?([4, 4], [5, 3], grid)
        expect(result).to eq(:blocked)
      end

      it 'cannot move diagonally down-right into a same-color piece' do
        grid = Array.new(8) { Array.new(8) }
        grid[4][4] = King.new('White')
        grid[3][5] = Pawn.new('White')

        result = grid[4][4].valid_move?([4, 4], [3, 5], grid)
        expect(result).to eq(:blocked)
      end

      it 'cannot move diagonally down-left into a same-color piece' do
        grid = Array.new(8) { Array.new(8) }
        grid[4][4] = King.new('White')
        grid[3][3] = Pawn.new('White')

        result = grid[4][4].valid_move?([4, 4], [3, 3], grid)
        expect(result).to eq(:blocked)
      end
    end
  end
end
