# spec/bishop_spec.rb
require 'spec_helper'
require_relative '../lib/bishop'

RSpec.describe Bishop do
  let(:bishop) { Bishop.new('White') }
  let(:empty_grid) { Array.new(8) { Array.new(8) } }

  context 'valid moves' do
    it 'can move up-right diagonally' do
      expect(bishop.valid_move?([4, 4], [6, 6], empty_grid)).to eq(:ok)
    end

    it 'can move up-left diagonally' do
      expect(bishop.valid_move?([4, 4], [6, 2], empty_grid)).to eq(:ok)
    end

    it 'can move down-right diagonally' do
      expect(bishop.valid_move?([4, 4], [2, 6], empty_grid)).to eq(:ok)
    end

    it 'can move down-left diagonally' do
      expect(bishop.valid_move?([4, 4], [2, 2], empty_grid)).to eq(:ok)
    end
  end

  context 'invalid moves' do
    it 'cannot move vertically' do
      expect(bishop.valid_move?([4, 4], [7, 4], empty_grid)).to eq(:illegal)
    end

    it 'cannot move horizontally' do
      expect(bishop.valid_move?([4, 4], [4, 7], empty_grid)).to eq(:illegal)
    end

    it 'cannot stay in place' do
      expect(bishop.valid_move?([4, 4], [4, 4], empty_grid)).to eq(:illegal)
    end
  end
end
