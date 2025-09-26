# spec/knight_spec.rb
require 'spec_helper'
require_relative '../lib/knight'
require_relative '../lib/pawn'

RSpec.describe Knight do
  let(:knight) { Knight.new('White') }
  let(:grid) { Array.new(8) { Array.new(8) } }

  context 'basic movement' do
    it 'can move 2 up, 1 left' do
      expect(knight.valid_move?([4, 4], [2, 3], grid)).to eq(:ok)
    end

    it 'can move 2 up, 1 right' do
      expect(knight.valid_move?([4, 4], [2, 5], grid)).to eq(:ok)
    end

    it 'can move 2 down, 1 left' do
      expect(knight.valid_move?([4, 4], [6, 3], grid)).to eq(:ok)
    end

    it 'can move 2 down, 1 right' do
      expect(knight.valid_move?([4, 4], [6, 5], grid)).to eq(:ok)
    end

    it 'can move 2 left, 1 up' do
      expect(knight.valid_move?([4, 4], [3, 2], grid)).to eq(:ok)
    end

    it 'can move 2 left, 1 down' do
      expect(knight.valid_move?([4, 4], [5, 2], grid)).to eq(:ok)
    end

    it 'can move 2 right, 1 up' do
      expect(knight.valid_move?([4, 4], [3, 6], grid)).to eq(:ok)
    end

    it 'can move 2 right, 1 down' do
      expect(knight.valid_move?([4, 4], [5, 6], grid)).to eq(:ok)
    end

    it 'cannot move in a straight line' do
      expect(knight.valid_move?([4, 4], [4, 6], grid)).to eq(:illegal)
    end

    it 'cannot move diagonally' do
      expect(knight.valid_move?([4, 4], [6, 6], grid)).to eq(:illegal)
    end
  end

  context 'interaction with other pieces' do
    it 'cannot land on a same-color piece' do
      grid[2][3] = Pawn.new('White')
      expect(knight.valid_move?([4, 4], [2, 3], grid)).to eq(:blocked)
    end

    it 'can capture an opposing piece' do
      grid[2][3] = Pawn.new('Black')
      expect(knight.valid_move?([4, 4], [2, 3], grid)).to eq(:capture)
    end
  end
end
