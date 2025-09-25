# spec/pawn_spec.rb
require 'spec_helper'
require_relative '../lib/pawn'

RSpec.describe Pawn do
  let(:empty_grid) { Array.new(8) { Array.new(8) } }

  context 'white pawn' do
    let(:pawn) { Pawn.new('White') }

    it 'can move forward one square' do
      expect(pawn.valid_move?([6, 4], [5, 4], empty_grid)).to eq(:ok)
    end

    it 'can move forward two squares on first move' do
      expect(pawn.valid_move?([6, 4], [4, 4], empty_grid)).to eq(:ok)
    end

    it 'cannot move backwards' do
      expect(pawn.valid_move?([5, 4], [6, 4], empty_grid)).to eq(:illegal)
    end

    it 'cannot move sideways' do
      expect(pawn.valid_move?([6, 4], [6, 5], empty_grid)).to eq(:illegal)
    end

    it 'can move diagonally one square (for capture)' do
      expect(pawn.valid_move?([6, 4], [5, 5], empty_grid)).to eq(:ok)
    end
  end

  context 'black pawn' do
    let(:pawn) { Pawn.new('Black') }

    it 'can move forward one square' do
      expect(pawn.valid_move?([1, 4], [2, 4], empty_grid)).to eq(:ok)
    end

    it 'can move forward two squares on first move' do
      expect(pawn.valid_move?([1, 4], [3, 4], empty_grid)).to eq(:ok)
    end

    it 'cannot move backwards' do
      expect(pawn.valid_move?([2, 4], [1, 4], empty_grid)).to eq(:illegal)
    end

    it 'cannot move sideways' do
      expect(pawn.valid_move?([1, 4], [1, 5], empty_grid)).to eq(:illegal)
    end

    it 'can move diagonally one square (for capture)' do
      expect(pawn.valid_move?([1, 4], [2, 5], empty_grid)).to eq(:ok)
    end
  end
end
