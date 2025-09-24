# spec/queen_spec.rb
require 'spec_helper'
require_relative '../lib/queen'

RSpec.describe Queen do
  let(:queen) { Queen.new('White') }
  let(:empty_grid) { Array.new(8) { Array.new(8) } }

  context 'valid moves' do
    it 'can move vertically down' do
      expect(queen.valid_move?([4, 4], [7, 4], empty_grid)).to eq(:ok)
    end

    it 'can move vertically up' do
      expect(queen.valid_move?([4, 4], [0, 4], empty_grid)).to eq(:ok)
    end

    it 'can move horizontally right' do
      expect(queen.valid_move?([4, 4], [4, 7], empty_grid)).to eq(:ok)
    end

    it 'can move horizontally left' do
      expect(queen.valid_move?([4, 4], [4, 0], empty_grid)).to eq(:ok)
    end

    it 'can move diagonally down-right' do
      expect(queen.valid_move?([4, 4], [7, 7], empty_grid)).to eq(:ok)
    end

    it 'can move diagonally down-left' do
      expect(queen.valid_move?([4, 4], [7, 1], empty_grid)).to eq(:ok)
    end

    it 'can move diagonally up-right' do
      expect(queen.valid_move?([4, 4], [1, 7], empty_grid)).to eq(:ok)
    end

    it 'can move diagonally up-left' do
      expect(queen.valid_move?([4, 4], [1, 1], empty_grid)).to eq(:ok)
    end
  end

  context 'invalid moves' do
    it 'cannot move like a knight' do
      expect(queen.valid_move?([4, 4], [6, 5], empty_grid)).to eq(:illegal)
    end

    it 'cannot stay in place' do
      expect(queen.valid_move?([4, 4], [4, 4], empty_grid)).to eq(:illegal)
    end

    it 'cannot move to a non-straight, non-diagonal square' do
      expect(queen.valid_move?([4, 4], [5, 6], empty_grid)).to eq(:illegal)
    end
  end
end
